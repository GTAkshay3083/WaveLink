import '../../music/models/song.dart';

class HostSession {
  final String sessionName;
  final Song selectedSong;
  final String roomCode;

  const HostSession({
    required this.sessionName,
    required this.selectedSong,
    required this.roomCode,
  });
}