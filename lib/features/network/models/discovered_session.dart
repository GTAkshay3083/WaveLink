class DiscoveredSession {
  final String sessionName;
  final String roomCode;
  final String hostIp;
  final int port;

  const DiscoveredSession({
    required this.sessionName,
    required this.roomCode,
    required this.hostIp,
    required this.port,
  });

  factory DiscoveredSession.fromJson(
    Map<String, dynamic> json,
  ) {
    return DiscoveredSession(
      sessionName: json['sessionName'],
      roomCode: json['roomCode'],
      hostIp: json['hostIp'],
      port: json['port'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionName': sessionName,
      'roomCode': roomCode,
      'hostIp': hostIp,
      'port': port,
    };
  }
}