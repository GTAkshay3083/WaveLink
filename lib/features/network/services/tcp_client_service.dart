import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../models/message_type.dart';

import 'package:flutter/foundation.dart';

import '../models/network_message.dart';

typedef ClientMessageHandler = void Function(
  NetworkMessage message,
);

class TcpClientService extends ChangeNotifier {
  Socket? _socket;

  StreamSubscription<List<int>>? _subscription;

  final StringBuffer _buffer = StringBuffer();

  ClientMessageHandler? onMessage;

  bool get isConnected => _socket != null;

  String? get connectedHost => _socket?.remoteAddress.address;

  int? get connectedPort => _socket?.remotePort;

  Future<bool> connect({
    required String host,
    required int port,
  }) async {
    if (_socket != null) {
      return true;
    }

    try {
      debugPrint("");
      debugPrint("==============================");
      debugPrint("Connecting to $host:$port");
      debugPrint("==============================");

      _socket = await Socket.connect(
        host,
        port,
        timeout: const Duration(seconds: 5),
      );

      debugPrint("==============================");
      debugPrint("TCP Client Connected");
      debugPrint("==============================");

      _subscription = _socket!.listen(
        _handleData,
        onDone: _handleDisconnect,
        onError: (error) {
          debugPrint("TCP Client Error: $error");
          disconnect();
        },
        cancelOnError: true,
      );

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint("Connection Failed: $e");
      await disconnect();
      return false;
    }
  }

  void send(NetworkMessage message) {
    if (_socket == null) return;

    _socket!.write("${message.encode()}\n");

    debugPrint("Sent: ${message.type.value}");
  }

  void _handleData(List<int> data) {
    _buffer.write(utf8.decode(data));

    final contents = _buffer.toString();

    final messages = contents.split('\n');

    _buffer.clear();

    if (!contents.endsWith('\n')) {
      _buffer.write(messages.removeLast());
    }

    for (final rawMessage in messages) {
      if (rawMessage.trim().isEmpty) {
        continue;
      }

      try {
        final message = NetworkMessage.decode(rawMessage);

        debugPrint("Received: ${message.type.value}");

        onMessage?.call(message);
      } catch (e) {
        debugPrint("Message Parse Error: $e");
      }
    }
  }

  Future<void> disconnect() async {
    await _subscription?.cancel();

    await _socket?.close();

    _subscription = null;
    _socket = null;

    _buffer.clear();

    debugPrint("TCP Client Disconnected");

    notifyListeners();
  }

  void _handleDisconnect() {
    debugPrint("Server closed connection");
    disconnect();
  }
}