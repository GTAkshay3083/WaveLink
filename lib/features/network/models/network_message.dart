import 'dart:convert';

import 'message_type.dart';

class NetworkMessage {
  final MessageType type;
  final Map<String, dynamic> payload;

  const NetworkMessage({
    required this.type,
    required this.payload,
  });

  Map<String, dynamic> toJson() {
    return {
      "type": type.value,
      "payload": payload,
    };
  }

  factory NetworkMessage.fromJson(
    Map<String, dynamic> json,
  ) {
    return NetworkMessage(
      type: MessageTypeExtension.fromString(
        json["type"],
      ),
      payload: Map<String, dynamic>.from(
        json["payload"],
      ),
    );
  }

  String encode() {
    return jsonEncode(toJson());
  }

  factory NetworkMessage.decode(
    String source,
  ) {
    return NetworkMessage.fromJson(
      jsonDecode(source),
    );
  }
}