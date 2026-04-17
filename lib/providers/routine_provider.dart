import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/routine_model.dart';
import '../services/notification_service.dart';
import 'settings_provider.dart';

class RoutineProvider extends ChangeNotifier {
  SettingsProvider? _settings;

  List<ClassRoutine> _routines = [];
  bool _isLoading = false;

  List<ClassRoutine> get routines => _routines;
  bool get isLoading => _isLoading;

  void setSettings(SettingsProvider settings) {
    if (_settings != settings) {
      _settings = settings;
      _scheduleAllNotifications();
    }
  }

  Future<void> fetchRoutines() async {
    _isLoading = true;
    notifyListeners();

    // Use your Google Sheet CSV URL here
    // String sheetUrl = 'https://docs.google.com/spreadsheets/d/YOUR_SHEET_ID/gviz/tq?tqx=out:csv&sheet=Sheet1';
    
    // Mock for now, but keeping the structure for you
    try {
      // final response = await http.get(Uri.parse(sheetUrl));
      // if (response.statusCode == 200) { /* Parse CSV here */ }
      
      await Future.delayed(const Duration(milliseconds: 500));
      _routines = [
        ClassRoutine(id: '1', day: 'Sun', courseCode: 'CSE 301', courseName: 'Algorithm Design', location: 'Room 302', startTime: '08:30 AM', endTime: '10:00 AM'),
        ClassRoutine(id: '2', day: 'Sun', courseCode: 'MAT 201', courseName: 'Linear Algebra', location: 'Room 410', startTime: '10:10 AM', endTime: '11:40 AM'),
        ClassRoutine(id: '3', day: 'Mon', courseCode: 'CSE 305', courseName: 'Database Systems', location: 'Room 305', startTime: '11:50 AM', endTime: '01:20 PM'),
        ClassRoutine(id: '4', day: 'Tue', courseCode: 'CSE 301', courseName: 'Algorithm Design', location: 'Room 302', startTime: '08:30 AM', endTime: '10:00 AM'),
        ClassRoutine(id: '5', day: 'Wed', courseCode: 'CSE 306', courseName: 'Database Lab', location: 'Lab 2', startTime: '02:30 PM', endTime: '05:30 PM'),
      ];
    } catch (e) {
      debugPrint('Error fetching sheet: $e');
    }
    
    _scheduleAllNotifications();
    _isLoading = false;
    notifyListeners();
  }

  void _scheduleAllNotifications() async {
    if (_settings == null) return;
    
    final ns = NotificationService();
    await ns.cancelAll();
    
    if (!_settings!.isClassReminderEnabled) {
      debugPrint('Class reminders disabled in settings.');
      return;
    }
    
    for (var r in _routines) {
      try {
        final time = DateFormat('hh:mm a').parse(r.startTime);
        final day = _dayToWeekday(r.day);
        
        await ns.scheduleClassReminder(
          id: r.id.hashCode,
          title: 'Upcoming Class: ${r.courseCode}',
          body: '${r.courseName} in ${r.location} starting soon!',
          dayOfWeek: day,
          hour: time.hour,
          minute: time.minute,
        );
      } catch (e) {
        debugPrint('Error scheduling notification: $e');
      }
    }
  }

  int _dayToWeekday(String day) {
    switch (day.toLowerCase().substring(0, 3)) {
      case 'mon': return DateTime.monday;
      case 'tue': return DateTime.tuesday;
      case 'wed': return DateTime.wednesday;
      case 'thu': return DateTime.thursday;
      case 'fri': return DateTime.friday;
      case 'sat': return DateTime.saturday;
      case 'sun': return DateTime.sunday;
      default: return DateTime.monday;
    }
  }

  Future<void> addRoutine(ClassRoutine routine) async {
    final newRoutine = ClassRoutine(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      day: routine.day,
      courseCode: routine.courseCode,
      courseName: routine.courseName,
      location: routine.location,
      startTime: routine.startTime,
      endTime: routine.endTime,
    );
    _routines.add(newRoutine);
    _scheduleAllNotifications();
    notifyListeners();
  }

  Future<void> deleteRoutine(String id) async {
    _routines.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}
