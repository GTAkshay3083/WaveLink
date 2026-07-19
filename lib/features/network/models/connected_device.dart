import 'dart:io';

class ConnectedDevice {
  final String id;
  final String name;
  final String ipAddress;
  final Socket socket;
  final DateTime connectedAt;

  const ConnectedDevice({
    required this.id,
    required this.name,
    required this.ipAddress,
    required this.socket,
    required this.connectedAt,
  });

  ConnectedDevice copyWith({
    String? id,
    String? name,
    String? ipAddress,
    Socket? socket,
    DateTime? connectedAt,
  }) {
    return ConnectedDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      ipAddress: ipAddress ?? this.ipAddress,
      socket: socket ?? this.socket,
      connectedAt: connectedAt ?? this.connectedAt,
    );
  }

  @override
  String toString() {
    return '''
ConnectedDevice(
  id: $id,
  name: $name,
  ip: $ipAddress
)
''';
  }
}