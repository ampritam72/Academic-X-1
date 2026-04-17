import 'package:cloud_firestore/cloud_firestore.dart';

class CourseGrade {
  final String id;
  final String term; // e.g., "Semester 1"
  final String courseCode;
  final String courseName;
  final double creditHours;
  final double gradePoint;

  CourseGrade({
    required this.id,
    required this.term,
    required this.courseCode,
    this.courseName = '',
    required this.creditHours,
    required this.gradePoint,
  });

  factory CourseGrade.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return CourseGrade(
      id: doc.id,
      term: data['term'] ?? '',
      courseCode: data['courseCode'] ?? '',
      courseName: data['courseName'] ?? '',
      creditHours: (data['creditHours'] ?? 0.0).toDouble(),
      gradePoint: (data['gradePoint'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'term': term,
      'courseCode': courseCode,
      'courseName': courseName,
      'creditHours': creditHours,
      'gradePoint': gradePoint,
    };
  }
}
