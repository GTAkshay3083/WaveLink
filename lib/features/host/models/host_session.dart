import '../../music/models/song.dart';
import 'device.dart';

class HostSession {
  final String sessionName;
  final Song selectedSong;
  final String roomCode;
  final List<Device> devices;

  const HostSession({
    required this.sessionName,
    required this.selectedSong,
    required this.roomCode,
    required this.devices,
  });
}