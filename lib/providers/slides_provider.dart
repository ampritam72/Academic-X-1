import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class SlidesProvider with ChangeNotifier {
  List<int> _savedSemesterIds = [];
  bool _isInitialized = false;
  final Map<int, double> _downloadProgress = {};
  final Map<int, bool> _isDownloading = {};

  SlidesProvider() {
    _loadFromPrefs();
  }

  bool isDownloaded(int semester) => _savedSemesterIds.contains(semester);
  bool isDownloading(int semester) => _isDownloading[semester] ?? false;
  double getProgress(int semester) => _downloadProgress[semester] ?? 0.0;

  Future<String> getLocalPath(int semester) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/semester_$semester.pdf';
  }

  Future<void> downloadSlide(int semester, String url) async {
    if (isDownloaded(semester) || isDownloading(semester)) return;

    _isDownloading[semester] = true;
    _downloadProgress[semester] = 0.0;
    notifyListeners();

    try {
      final dio = Dio();
      final savePath = await getLocalPath(semester);

      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            _downloadProgress[semester] = received / total;
            notifyListeners();
          }
        },
      );

      if (!_savedSemesterIds.contains(semester)) {
        _savedSemesterIds.add(semester);
      }
      await _saveToPrefs();
    } catch (e) {
      debugPrint('Download error: $e');
    } finally {
      _isDownloading[semester] = false;
      _downloadProgress.remove(semester);
      notifyListeners();
    }
  }

  Future<void> removeDownloaded(int semester) async {
    try {
      final path = await getLocalPath(semester);
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
      _savedSemesterIds.remove(semester);
      await _saveToPrefs();
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting file: $e');
    }
  }

  List<int> getSavedSlides() {
    List<int> sorted = List.from(_savedSemesterIds);
    sorted.sort();
    return sorted;
  }

  Future<void> _loadFromPrefs() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? saved = prefs.getStringList('saved_slides');
      if (saved != null) {
        _savedSemesterIds = saved.map((e) => int.parse(e)).toList();
      }
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading slides: $e');
    }
  }

  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        'saved_slides',
        _savedSemesterIds.map((e) => e.toString()).toList(),
      );
    } catch (e) {
      debugPrint('Error saving slides: $e');
    }
  }
}
