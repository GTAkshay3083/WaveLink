import 'package:flutter/material.dart';

import '../models/host_session.dart';

class HostSessionScreen extends StatelessWidget {
  final HostSession session;

  const HostSessionScreen({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Host Session"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.music_note,
                  size: 40,
                ),
                title: Text(session.selectedSong.title),
                subtitle: Text(session.selectedSong.artist),
              ),
            ),

            const SizedBox(height: 25),

            Text(
              "Session Name",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 8),

            Card(
              child: ListTile(
                title: Text(session.sessionName),
              ),
            ),

            const SizedBox(height: 25),

            Text(
              "Room Code",
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
                    letterSpacing: 3,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Text(
              "Connected Devices",
              style: Theme.of(context).textTheme.titleMedium,
            ),

            const SizedBox(height: 8),

            const Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.phone_android),
                ),
                title: Text("Host Device"),
                subtitle: Text("1 device connected"),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: null,
                icon: const Icon(Icons.play_arrow),
                label: const Text("Start Music"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}