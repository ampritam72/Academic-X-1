import 'package:flutter/material.dart';
import '../models/cgpa_model.dart';

class CGPAProvider extends ChangeNotifier {
  List<CourseGrade> _grades = [];
  bool _isLoading = false;

  List<CourseGrade> get grades => _grades;
  bool get isLoading => _isLoading;

  double get overallCGPA {
    if (_grades.isEmpty) return 0.0;
    double totalPoints = 0;
    double totalCredits = 0;

    for (var grade in _grades) {
      totalPoints += (grade.gradePoint * grade.creditHours);
      totalCredits += grade.creditHours;
    }

    return totalCredits == 0 ? 0.0 : totalPoints / totalCredits;
  }

  Future<void> fetchGrades() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 400));
    _grades = [
      CourseGrade(
          id: '1',
          term: 'Semester 1',
          courseCode: 'CSE 101',
          courseName: 'Intro to Programming',
          creditHours: 3.0,
          gradePoint: 4.0),
      CourseGrade(
          id: '2',
          term: 'Semester 1',
          courseCode: 'MAT 101',
          courseName: 'Calculus I',
          creditHours: 3.0,
          gradePoint: 3.7),
      CourseGrade(
          id: '3',
          term: 'Semester 1',
          courseCode: 'PHY 101',
          courseName: 'Physics I',
          creditHours: 3.0,
          gradePoint: 3.3),
      CourseGrade(
          id: '4',
          term: 'Semester 2',
          courseCode: 'CSE 102',
          courseName: 'Data Structures',
          creditHours: 3.0,
          gradePoint: 4.0),
      CourseGrade(
          id: '5',
          term: 'Semester 2',
          courseCode: 'MAT 102',
          courseName: 'Calculus II',
          creditHours: 3.0,
          gradePoint: 3.3),
    ];

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addGrade(CourseGrade grade) async {
    final newGrade = CourseGrade(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      term: grade.term,
      courseCode: grade.courseCode,
      courseName: grade.courseName,
      creditHours: grade.creditHours,
      gradePoint: grade.gradePoint,
    );
    _grades.add(newGrade);
    notifyListeners();
  }

  /// Adds a course to [semesterNumber] (1–8). Term label is `Semester N`.
  Future<void> addCourseToSemester({
    required int semesterNumber,
    required String courseName,
    required String courseCode,
    required double creditHours,
    required double gradePoint,
  }) async {
    if (semesterNumber < 1 || semesterNumber > 8) return;
    await addGrade(CourseGrade(
      id: '',
      term: 'Semester $semesterNumber',
      courseCode: courseCode,
      courseName: courseName,
      creditHours: creditHours,
      gradePoint: gradePoint,
    ));
  }

  Future<void> deleteGrade(String id) async {
    _grades.removeWhere((g) => g.id == id);
    notifyListeners();
  }
}
