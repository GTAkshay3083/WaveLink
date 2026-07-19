import 'dart:io';

import 'package:flutter/foundation.dart';

import '../models/connected_device.dart';
import '../models/message_type.dart';
import '../models/network_message.dart';
import 'discovery_service.dart';
import 'tcp_client_service.dart';
import 'tcp_server_service.dart';

class ConnectionManager extends ChangeNotifier {
  ConnectionManager({
    required this.discoveryService,
    required this.tcpServer,
    required this.tcpClient,
  }) {
    tcpServer.onMessage = _handleServerMessage;
    tcpClient.onMessage = _handleClientMessage;
  }

  final DiscoveryService discoveryService;
  final TcpServerService tcpServer;
  final TcpClientService tcpClient;

  final List<ConnectedDevice> _devices = [];

  bool _isHosting = false;
  bool _isConnected = false;

  bool get isHosting => _isHosting;

  bool get isConnected => _isConnected;

  List<ConnectedDevice> get devices => List.unmodifiable(_devices);

  Future<void> startHosting({
    required String sessionName,
    required String roomCode,
  }) async {
    if (_isHosting) return;

    await tcpServer.startServer();

    await discoveryService.startBroadcast(
      sessionName: sessionName,
      roomCode: roomCode,
      tcpPort: TcpServerService.port,
    );

    _isHosting = true;

    notifyListeners();
  }

  Future<void> stopHosting() async {
    await discoveryService.stopBroadcast();
    await tcpServer.stopServer();

    _devices.clear();

    _isHosting = false;

    notifyListeners();
  }

  Future<bool> joinHost({
    required String host,
    required int port,
  }) async {
    final connected = await tcpClient.connect(
      host: host,
      port: port,
    );

    _isConnected = connected;

    notifyListeners();

    return connected;
  }

  Future<void> leaveHost() async {
    await tcpClient.disconnect();

    _devices.clear();

    _isConnected = false;

    notifyListeners();
  }

  void _handleServerMessage(
    Socket socket,
    NetworkMessage message,
  ) {
    switch (message.type) {
      case MessageType.join:
        debugPrint(
          "JOIN received from ${socket.remoteAddress.address}",
        );
        break;

      default:
        debugPrint(
          "Unhandled server message: ${message.type.value}",
        );
    }
  }

  void _handleClientMessage(
    NetworkMessage message,
  ) {
    switch (message.type) {
      default:
        debugPrint(
          "Unhandled client message: ${message.type.value}",
        );
    }
  }
}