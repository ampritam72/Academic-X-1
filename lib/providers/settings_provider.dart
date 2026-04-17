import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _classReminderKey = 'isClassReminderEnabled';
  static const String _languageKey = 'isBangla';
  
  bool _isClassReminderEnabled = true;
  bool _isBangla = false;

  bool get isClassReminderEnabled => _isClassReminderEnabled;
  bool get isBangla => _isBangla;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isClassReminderEnabled = prefs.getBool(_classReminderKey) ?? true;
    _isBangla = prefs.getBool(_languageKey) ?? false;
    notifyListeners();
  }

  Future<void> toggleClassReminder(bool value) async {
    _isClassReminderEnabled = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_classReminderKey, value);
    notifyListeners();
  }

  Future<void> toggleLanguage(bool value) async {
    _isBangla = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_languageKey, value);
    notifyListeners();
  }
}
