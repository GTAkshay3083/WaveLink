import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/network_message.dart';

typedef MessageHandler = void Function(
  Socket socket,
  NetworkMessage message,
);

class TcpServerService extends ChangeNotifier {
  ServerSocket? _server;

  final List<Socket> _clients = [];
  final Map<Socket, StringBuffer> _buffers = {};

  MessageHandler? onMessage;

  bool get isRunning => _server != null;

  int get clientCount => _clients.length;

  List<Socket> get clients => List.unmodifiable(_clients);

  static const int port = 4040;

  Future<void> startServer() async {
    if (_server != null) return;

    try {
      _server = await ServerSocket.bind(
        InternetAddress.anyIPv4,
        port,
      );

      debugPrint("");
      debugPrint("==============================");
      debugPrint("WaveLink TCP Server Started");
      debugPrint("Listening on port $port");
      debugPrint("==============================");

      _server!.listen(_handleClient);

      notifyListeners();
    } catch (e) {
      debugPrint("TCP Server Error: $e");
    }
  }

  void _handleClient(Socket socket) {
    _clients.add(socket);
    _buffers[socket] = StringBuffer();

    debugPrint("");
    debugPrint("==============================");
    debugPrint(
      "Client Connected: ${socket.remoteAddress.address}:${socket.remotePort}",
    );
    debugPrint("Connected Clients: ${_clients.length}");
    debugPrint("==============================");

    socket.listen(
      (data) => _handleData(socket, data),
      onDone: () => _handleDisconnect(socket),
      onError: (error) {
        debugPrint("Client Error: $error");
        _handleDisconnect(socket);
      },
      cancelOnError: true,
    );

    notifyListeners();
  }

  void _handleData(
    Socket socket,
    List<int> data,
  ) {
    final buffer = _buffers[socket];

    if (buffer == null) return;

    buffer.write(utf8.decode(data));

    final contents = buffer.toString();

    final messages = contents.split('\n');

    buffer.clear();

    if (!contents.endsWith('\n')) {
      buffer.write(messages.removeLast());
    }

    for (final rawMessage in messages) {
      if (rawMessage.trim().isEmpty) {
        continue;
      }

      try {
        final message = NetworkMessage.decode(rawMessage);

        debugPrint(
          "Received: ${message.type}",
        );

        onMessage?.call(
          socket,
          message,
        );
      } catch (e) {
        debugPrint("Message Parse Error: $e");
      }
    }
  }

  void send(
    Socket socket,
    NetworkMessage message,
  ) {
    socket.write("${message.encode()}\n");
  }

  void broadcast(NetworkMessage message) {
    for (final client in List<Socket>.from(_clients)) {
      send(client, message);
    }
  }

  void _handleDisconnect(Socket socket) {
    debugPrint("");
    debugPrint("==============================");
    debugPrint(
      "Client Disconnected: ${socket.remoteAddress.address}",
    );
    debugPrint(
      "Connected Clients: ${_clients.length - 1}",
    );
    debugPrint("==============================");

    _clients.remove(socket);
    _buffers.remove(socket);

    socket.destroy();

    notifyListeners();
  }

  Future<void> stopServer() async {
    for (final client in List<Socket>.from(_clients)) {
      await client.close();
    }

    _clients.clear();
    _buffers.clear();

    await _server?.close();
    _server = null;

    debugPrint("");
    debugPrint("==============================");
    debugPrint("TCP Server Stopped");
    debugPrint("==============================");

    notifyListeners();
  }
}