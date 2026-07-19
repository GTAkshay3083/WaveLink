import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/discovered_session.dart';
import '../models/message_type.dart';
import '../models/network_message.dart';

class DiscoveryService extends ChangeNotifier {
  static const int discoveryPort = 4041;

  RawDatagramSocket? _broadcastSocket;
  RawDatagramSocket? _listenSocket;

  Timer? _broadcastTimer;

  final List<DiscoveredSession> _sessions = [];

  List<DiscoveredSession> get sessions =>
      List.unmodifiable(_sessions);

  bool get isBroadcasting => _broadcastTimer != null;

  bool get isListening => _listenSocket != null;

  Future<void> startBroadcast({
    required String sessionName,
    required String roomCode,
    required int tcpPort,
  }) async {
    if (_broadcastTimer != null) return;

    try {
      _broadcastSocket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        0,
      );

      _broadcastSocket!.broadcastEnabled = true;

      debugPrint("==============================");
      debugPrint("UDP Discovery Started");
      debugPrint("==============================");

      _broadcastTimer = Timer.periodic(
        const Duration(seconds: 1),
        (_) {
          final message = NetworkMessage(
            type: MessageType.discovery,
            payload: {
              "sessionName": sessionName,
              "roomCode": roomCode,
              "hostIp": "",
              "port": tcpPort,
            },
          );

          final bytes = utf8.encode(message.encode());

          _broadcastSocket!.send(
            bytes,
            InternetAddress("255.255.255.255"),
            discoveryPort,
          );
        },
      );

      notifyListeners();
    } catch (e) {
      debugPrint("Discovery Broadcast Error: $e");
    }
  }

  Future<void> startListening() async {
    if (_listenSocket != null) return;

    try {
      _listenSocket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        discoveryPort,
      );

      debugPrint("==============================");
      debugPrint("Listening For Sessions...");
      debugPrint("==============================");

      _listenSocket!.listen((event) {
        if (event != RawSocketEvent.read) return;

        final datagram = _listenSocket!.receive();

        if (datagram == null) return;

        try {
          final message = NetworkMessage.decode(
            utf8.decode(datagram.data),
          );

          if (message.type != MessageType.discovery) {
            return;
          }

          final payload =
              Map<String, dynamic>.from(message.payload);

          payload["hostIp"] = datagram.address.address;

          final session =
              DiscoveredSession.fromJson(payload);

          final exists = _sessions.any(
            (s) =>
                s.roomCode == session.roomCode &&
                s.hostIp == session.hostIp,
          );

          if (!exists) {
            _sessions.add(session);

            debugPrint(
              "Found Session: ${session.sessionName}",
            );

            notifyListeners();
          }
        } catch (e) {
          debugPrint("Discovery Parse Error: $e");
        }
      });

      notifyListeners();
    } catch (e) {
      debugPrint("Discovery Listen Error: $e");
    }
  }

  Future<void> stopBroadcast() async {
    _broadcastTimer?.cancel();
    _broadcastTimer = null;

    _broadcastSocket?.close();
    _broadcastSocket = null;

    notifyListeners();
  }

  Future<void> stopListening() async {
    _listenSocket?.close();
    _listenSocket = null;

    _sessions.clear();

    notifyListeners();
  }
}