import 'package:cloud_firestore/cloud_firestore.dart';

class Notice {
  final String id;
  final String title;
  final String body;
  final String sender;
  final DateTime timestamp;
  final bool isImportant;

  Notice({
    required this.id,
    required this.title,
    required this.body,
    required this.sender,
    required this.timestamp,
    this.isImportant = false,
  });

  factory Notice.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Notice(
      id: doc.id,
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      sender: data['sender'] ?? 'Admin',
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isImportant: data['isImportant'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'sender': sender,
      'timestamp': FieldValue.serverTimestamp(),
      'isImportant': isImportant,
    };
  }
}
