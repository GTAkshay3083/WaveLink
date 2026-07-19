class Song {
  final String title;
  final String artist;
  final String? albumArt;

  const Song({
    required this.title,
    required this.artist,
    this.albumArt,
  });
}