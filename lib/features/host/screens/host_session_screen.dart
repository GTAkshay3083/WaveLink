import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/device.dart';
import '../services/host_service.dart';

class HostSessionScreen extends ConsumerWidget {
  const HostSessionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(hostServiceProvider);

    if (session == null) {
      return const Scaffold(
        body: Center(
          child: Text('No active session'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Host Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.music_note, size: 40),
                title: Text(session.selectedSong.title),
                subtitle: Text(session.selectedSong.artist),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Session Name',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                title: Text(session.sessionName),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Room Code',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.key),
                title: Text(
                  session.roomCode,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Connected Devices',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: session.devices.length,
                itemBuilder: (context, index) {
                  final Device device = session.devices[index];

                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Icon(
                          device.isHost
                              ? Icons.wifi_tethering
                              : Icons.phone_android,
                        ),
                      ),
                      title: Text(device.name),
                      subtitle: Text(
                        device.isHost ? 'Host' : 'Guest',
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Music'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}