import 'package:flutter/material.dart';

import '../models/song.dart';

class MusicLibraryScreen extends StatelessWidget {
  const MusicLibraryScreen({super.key});

  static const List<Song> songs = [
    Song(
      title: 'Believer',
      artist: 'Imagine Dragons',
    ),
    Song(
      title: 'Heat Waves',
      artist: 'Glass Animals',
    ),
    Song(
      title: 'Bones',
      artist: 'Imagine Dragons',
    ),
    Song(
      title: 'Blinding Lights',
      artist: 'The Weeknd',
    ),
    Song(
      title: 'Naa Ready',
      artist: 'Anirudh Ravichander',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Music'),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];

          return ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.music_note),
            ),
            title: Text(song.title),
            subtitle: Text(song.artist),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pop(context, song);
            },
          );
        },
      ),
    );
  }
}