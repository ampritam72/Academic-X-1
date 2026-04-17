import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String email;
  final String name;
  final String studentId;
  final String role; // 'student', 'cr', 'instructor'
  final double cgpa;
  final String section;
  final int semester;
  final int batch;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> metadata;

  User({
    required this.uid,
    required this.email,
    required this.name,
    required this.studentId,
    this.role = 'student',
    this.cgpa = 0.0,
    this.section = '',
    this.semester = 0,
    this.batch = 0,
    required this.createdAt,
    required this.updatedAt,
    this.metadata = const {},
  });

  /// Create User from Firestore document
  factory User.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return User(
      uid: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      studentId: data['studentId'] ?? '',
      role: data['role'] ?? 'student',
      cgpa: (data['cgpa'] ?? 0.0).toDouble(),
      section: data['section'] ?? '',
      semester: data['semester'] ?? 0,
      batch: data['batch'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      metadata: data['metadata'] ?? {},
    );
  }

  /// Convert User to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'studentId': studentId,
      'role': role,
      'cgpa': cgpa,
      'section': section,
      'semester': semester,
      'batch': batch,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'metadata': metadata,
    };
  }

  /// Create a copy with modified fields
  User copyWith({
    String? uid,
    String? email,
    String? name,
    String? studentId,
    String? role,
    double? cgpa,
    String? section,
    int? semester,
    int? batch,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      studentId: studentId ?? this.studentId,
      role: role ?? this.role,
      cgpa: cgpa ?? this.cgpa,
      section: section ?? this.section,
      semester: semester ?? this.semester,
      batch: batch ?? this.batch,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  String toString() {
    return 'User(uid: $uid, name: $name, email: $email, role: $role, section: $section)';
  }
}
