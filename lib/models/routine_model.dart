import 'package:cloud_firestore/cloud_firestore.dart';

class ClassRoutine {
  final String id;
  final String day;
  final String courseCode;
  final String courseName;
  final String location;
  final String startTime;
  final String endTime;

  ClassRoutine({
    required this.id,
    required this.day,
    required this.courseCode,
    required this.courseName,
    required this.location,
    required this.startTime,
    required this.endTime,
  });

  factory ClassRoutine.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return ClassRoutine(
      id: doc.id,
      day: data['day'] ?? '',
      courseCode: data['courseCode'] ?? '',
      courseName: data['courseName'] ?? '',
      location: data['location'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'courseCode': courseCode,
      'courseName': courseName,
      'location': location,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
