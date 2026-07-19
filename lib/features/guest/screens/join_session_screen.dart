import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../host/services/host_service.dart';

class JoinSessionScreen extends ConsumerStatefulWidget {
  const JoinSessionScreen({super.key});

  @override
  ConsumerState<JoinSessionScreen> createState() =>
      _JoinSessionScreenState();
}

class _JoinSessionScreenState
    extends ConsumerState<JoinSessionScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(networkServiceProvider).startDiscovery();
    });
  }

  @override
  void dispose() {
    ref.read(networkServiceProvider).stopDiscovery();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final networkService = ref.watch(networkServiceProvider);

    final sessions = networkService.discoveredSessions;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Join Session"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: sessions.isEmpty
            ? const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text(
                      "Scanning for nearby sessions...",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            session.sessionName,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Room: ${session.roomCode}",
                          ),
                          Text(
                            "Host: ${session.hostIp}",
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // TCP connection comes next
                              },
                              child: const Text("Join"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}