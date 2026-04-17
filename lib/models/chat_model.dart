import 'package:cloud_firestore/cloud_firestore.dart';

enum ChatMessageType { user, ai }

class ChatMessage {
  final String id;
  final String text;
  final ChatMessageType type;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.text,
    required this.type,
    required this.timestamp,
  });

  factory ChatMessage.fromMap(String id, Map<String, dynamic> map) {
    return ChatMessage(
      id: id,
      text: map['text'] ?? '',
      type: map['type'] == 'user' ? ChatMessageType.user : ChatMessageType.ai,
      timestamp: (map['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'type': type == ChatMessageType.user ? 'user' : 'ai',
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}

class ChatConversation {
  final String id;
  final String name;
  final String lastMessage;
  final String type; // 'ai', 'personal', 'group'

  ChatConversation({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.type,
  });

  factory ChatConversation.fromMap(String id, Map<String, dynamic> map) {
    return ChatConversation(
      id: id,
      name: map['name'] ?? '',
      lastMessage: map['lastMessage'] ?? '',
      type: map['type'] ?? 'personal',
    );
  }
}
