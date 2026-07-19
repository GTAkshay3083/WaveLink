import 'package:flutter/foundation.dart';

import 'discovery_service.dart';
import 'tcp_server_service.dart';

class NetworkService extends ChangeNotifier {
  final TcpServerService _tcpServer = TcpServerService();
  final DiscoveryService _discoveryService = DiscoveryService();

  bool get isHosting => _tcpServer.isRunning;

  List get discoveredSessions => _discoveryService.sessions;

  Future<void> startHosting({
    required String sessionName,
    required String roomCode,
  }) async {
    await _tcpServer.startServer();

    await _discoveryService.startBroadcast(
      sessionName: sessionName,
      roomCode: roomCode,
      tcpPort: TcpServerService.port,
    );

    notifyListeners();
  }

  Future<void> stopHosting() async {
    await _discoveryService.stopBroadcast();
    await _tcpServer.stopServer();

    notifyListeners();
  }

  Future<void> startDiscovery() async {
    _discoveryService.addListener(_onDiscoveryChanged);

    await _discoveryService.startListening();

    notifyListeners();
  }

  Future<void> stopDiscovery() async {
    _discoveryService.removeListener(_onDiscoveryChanged);

    await _discoveryService.stopListening();

    notifyListeners();
  }

  void _onDiscoveryChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _discoveryService.removeListener(_onDiscoveryChanged);
    super.dispose();
  }
}