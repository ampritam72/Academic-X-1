import 'package:flutter/material.dart';
import 'dart:async';
import '../models/notice_model.dart';
import '../services/firestore_service.dart';
import 'auth_provider.dart';

class NoticeProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  late AuthProvider _authProvider;

  List<Notice> _notices = [];
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription? _noticeSubscription;

  List<Notice> get notices => _notices;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Create with optional auth provider for dependency injection
  NoticeProvider({AuthProvider? authProvider}) {
    if (authProvider != null) {
      _authProvider = authProvider;
      _setupNoticeListener();
    } else {
      // Fallback for backward compatibility
      _loadMockNotices();
    }
  }

  /// Update auth provider and setup listener
  void setAuthProvider(AuthProvider authProvider) {
    _authProvider = authProvider;
    _setupNoticeListener();
  }

  /// Setup real-time notice listener
  void _setupNoticeListener() {
    // Cancel previous subscription if exists
    _noticeSubscription?.cancel();

    // Only setup if user is authenticated
    if (!_authProvider.isAuthenticated) {
      _notices = [];
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final userSection = _authProvider.userData?['section'] ?? 'general';

      _noticeSubscription = _firestoreService
          .getNoticesForUser(userSection)
          .listen(
            (noticeDataList) {
              _notices = noticeDataList
                  .map((data) => _mapToNotice(data))
                  .toList();
              _isLoading = false;
              _errorMessage = null;
              notifyListeners();
              debugPrint('✓ Loaded ${_notices.length} notices for section: $userSection');
            },
            onError: (e) {
              _errorMessage = 'Failed to load notices';
              _isLoading = false;
              debugPrint('✗ Notice stream error: $e');
              notifyListeners();
            },
          );
    } catch (e) {
      _errorMessage = 'Error setting up notices: $e';
      _isLoading = false;
      debugPrint('✗ Setup notice listener error: $e');
      notifyListeners();
    }

    // Listen for auth state changes
    _authProvider.addListener(_onAuthStateChanged);
  }

  /// Handle auth state changes
  void _onAuthStateChanged() {
    if (!_authProvider.isAuthenticated) {
      _noticeSubscription?.cancel();
      _notices = [];
      notifyListeners();
    } else if (_notices.isEmpty && !_isLoading) {
      // User logged back in, reload notices
      _setupNoticeListener();
    }
  }

  /// Convert Firestore map to Notice object
  Notice _mapToNotice(Map<String, dynamic> data) {
    return Notice(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      sender: data['sender'] ?? 'Admin',
      timestamp: (data['timestamp'] as dynamic)?.toDate() ?? DateTime.now(),
      isImportant: data['isImportant'] ?? false,
    );
  }

  /// Add a new notice (CR only)
  Future<void> addNotice(String title, String body, String sender, bool isImportant) async {
    if (!_authProvider.isAuthenticated) {
      _errorMessage = 'Must be logged in to add notices';
      notifyListeners();
      return;
    }

    if (_authProvider.userData?['role'] != 'cr') {
      _errorMessage = 'Only class representatives can add notices';
      notifyListeners();
      return;
    }

    try {
      final noticeData = {
        'title': title,
        'body': body,
        'sender': sender,
        'isImportant': isImportant,
        'section': _authProvider.userData?['section'] ?? 'general',
        'createdBy': _authProvider.user?.uid,
      };

      final noticeId = await _firestoreService.addNotice(noticeData);
      debugPrint('✓ Notice added: $noticeId');
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to add notice: $e';
      debugPrint('✗ Add notice error: $e');
    }
    notifyListeners();
  }

  /// Load mock notices (fallback for development)
  void _loadMockNotices() {
    _isLoading = true;
    notifyListeners();

    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 300), () {
      _notices = [
        Notice(
          id: '1',
          title: 'Data Structures Quiz',
          body: 'The quiz on Binary Search Trees has been rescheduled to next Sunday.',
          sender: 'Dr. Jane Smith',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isImportant: true,
        ),
        Notice(
          id: '2',
          title: 'Library New Policy',
          body: 'The library will now stay open until 10 PM on weekdays.',
          sender: 'Admin',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isImportant: false,
        ),
        Notice(
          id: '3',
          title: 'Industrial Trip',
          body: 'Please register for the upcoming industrial trip by Wednesday.',
          sender: 'Dept. Office',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          isImportant: true,
        ),
      ];
      _isLoading = false;
      notifyListeners();
    });
  }

  /// Refresh notices manually
  Future<void> fetchNotices() async {
    if (_authProvider.isAuthenticated) {
      // The stream listener will update automatically
      debugPrint('✓ Notices are auto-updating via stream');
    } else {
      _loadMockNotices();
    }
  }

  /// Stream of notices for UI
  Stream<List<Notice>> get noticeStream {
    if (_authProvider.isAuthenticated) {
      return Stream.value(_notices);
    }
    return Stream.value([]);
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _noticeSubscription?.cancel();
    _authProvider.removeListener(_onAuthStateChanged);
    super.dispose();
  }
}
