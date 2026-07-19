import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../network/services/network_service.dart';
import '../models/host_session.dart';

final networkServiceProvider = Provider<NetworkService>(
  (ref) => NetworkService(),
);

final hostServiceProvider =
    StateNotifierProvider<HostService, HostSession?>(
  (ref) => HostService(
    ref.read(networkServiceProvider),
  ),
);

class HostService extends StateNotifier<HostSession?> {
  final NetworkService networkService;

  HostService(this.networkService) : super(null);

  Future<void> createSession(HostSession session) async {
    await networkService.startHosting(
      sessionName: session.sessionName,
      roomCode: session.roomCode,
    );

    state = session;
  }

  Future<void> endSession() async {
    await networkService.stopHosting();
    state = null;
  }

  bool get hasSession => state != null;
}