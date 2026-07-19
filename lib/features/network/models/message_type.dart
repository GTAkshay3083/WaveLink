enum MessageType {
  discovery,
  join,
  joinAccepted,
  joinRejected,
  deviceList,
  play,
  pause,
  seek,
  volume,
  heartbeat,
  disconnect,
}

extension MessageTypeExtension on MessageType {
  String get value {
    switch (this) {
      case MessageType.discovery:
        return "discovery";
      case MessageType.join:
        return "join";
      case MessageType.joinAccepted:
        return "joinAccepted";
      case MessageType.joinRejected:
        return "joinRejected";
      case MessageType.deviceList:
        return "deviceList";
      case MessageType.play:
        return "play";
      case MessageType.pause:
        return "pause";
      case MessageType.seek:
        return "seek";
      case MessageType.volume:
        return "volume";
      case MessageType.heartbeat:
        return "heartbeat";
      case MessageType.disconnect:
        return "disconnect";
    }
  }

  static MessageType fromString(String value) {
    return MessageType.values.firstWhere(
      (type) => type.value == value,
    );
  }
}