import 'package:flutter/foundation.dart';

import '../models/connected_device.dart';
import 'discovery_service.dart';
import 'tcp_client_service.dart';
import 'tcp_server_service.dart';

class ConnectionManager extends ChangeNotifier {
  ConnectionManager({
    required this.discoveryService,
    required this.tcpServer,
    required this.tcpClient,
  });

  final DiscoveryService discoveryService;
  final TcpServerService tcpServer;
  final TcpClientService tcpClient;

  final List<ConnectedDevice> _devices = [];

  bool _isHosting = false;
  bool _isConnected = false;

  bool get isHosting => _isHosting;

  bool get isConnected => _isConnected;

  List<ConnectedDevice> get devices =>
      List.unmodifiable(_devices);

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

  void addDevice(ConnectedDevice device) {
    _devices.removeWhere(
      (d) => d.id == device.id,
    );

    _devices.add(device);

    notifyListeners();
  }

  void removeDevice(String id) {
    _devices.removeWhere(
      (d) => d.id == id,
    );

    notifyListeners();
  }

  void clearDevices() {
    _devices.clear();

    notifyListeners();
  }
}