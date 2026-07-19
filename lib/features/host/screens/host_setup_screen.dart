import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../music/models/song.dart';
import '../../music/screens/music_library_screen.dart';
import '../models/device.dart';
import '../models/host_session.dart';
import '../services/host_service.dart';
import 'host_session_screen.dart';

class HostSetupScreen extends ConsumerStatefulWidget {
  const HostSetupScreen({super.key});

  @override
  ConsumerState<HostSetupScreen> createState() => _HostSetupScreenState();
}

class _HostSetupScreenState extends ConsumerState<HostSetupScreen> {
  Song? selectedSong;

  final TextEditingController sessionController = TextEditingController();

  Future<void> _chooseSong() async {
    final Song? song = await Navigator.push<Song>(
      context,
      MaterialPageRoute(
        builder: (_) => const MusicLibraryScreen(),
      ),
    );

    if (song != null) {
      setState(() {
        selectedSong = song;
      });
    }
  }

  String _generateRoomCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();

    return List.generate(
      6,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  Future<void> _continue() async {
    if (selectedSong == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please choose a song first.'),
        ),
      );
      return;
    }

    final sessionName = sessionController.text.trim().isEmpty
        ? 'My Awesome Party'
        : sessionController.text.trim();

    final session = HostSession(
      sessionName: sessionName,
      selectedSong: selectedSong!,
      roomCode: _generateRoomCode(),
      devices: const [
        Device(
          id: 'host',
          name: 'Host Device',
          isHost: true,
        ),
      ],
    );

    await ref.read(hostServiceProvider.notifier).createSession(session);

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const HostSessionScreen(),
      ),
    );
  }

  @override
  void dispose() {
    sessionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Host a Session'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Session Name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: sessionController,
              decoration: InputDecoration(
                hintText: 'My Awesome Party',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Selected Song',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Card(
              child: ListTile(
                leading: const Icon(Icons.music_note),
                title: Text(
                  selectedSong?.title ?? 'No song selected',
                ),
                subtitle: Text(
                  selectedSong?.artist ?? 'Choose a local song',
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _chooseSong,
                icon: const Icon(Icons.library_music),
                label: const Text('Choose Music'),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _continue,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}