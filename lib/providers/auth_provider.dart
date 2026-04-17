import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../services/firebase_service.dart';
import '../services/firestore_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _user;
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  String? _errorMessage;

  // Getters
  User? get user => _user;
  Map<String, dynamic>? get userData => _userData;
  bool get isLoading => _isLoading;
  bool get isCR => _userData?['role'] == 'cr';
  bool get isAuthenticated => _user != null;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _initializeAuth();
  }

  /// Initialize auth state changes listener
  void _initializeAuth() {
    _firebaseService.authStateChanges.listen((fbUser) {
      if (fbUser != null) {
        _loadUserProfile(fbUser.uid);
      } else {
        _user = null;
        _userData = null;
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  /// Load user profile from Firestore
  Future<void> _loadUserProfile(String uid) async {
    try {
      final profile = await _firestoreService.getUserProfile(uid);
      if (profile != null) {
        _user = profile;
        _userData = profile.toMap();
        _errorMessage = null;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load profile: $e';
      debugPrint('✗ Profile load error: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login with email and password
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential = await _firebaseService.auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user != null) {
        await _loadUserProfile(userCredential.user!.uid);
        debugPrint('✓ Login successful: ${userCredential.user!.email}');
      }
    } on fb.FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e.code);
      debugPrint('✗ Login error [${e.code}]: ${e.message}');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      debugPrint('✗ Login error: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Register with email, password, and student ID
  Future<void> register(String name, String email, String password, String studentId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Step 1: Verify student ID exists
      bool studentExists = await _firestoreService.verifyStudentId(studentId);
      if (!studentExists) {
        _errorMessage = 'Student ID not found in system';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Step 2: Get student ID data (section, semester, batch, role)
      final studentData = await _firestoreService.getStudentIdData(studentId);
      if (studentData == null) {
        _errorMessage = 'Invalid student ID';
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Step 3: Create Firebase auth user
      final userCredential = await _firebaseService.auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user != null) {
        final uid = userCredential.user!.uid;

        // Step 4: Create user profile in Firestore
        final newUser = User(
          uid: uid,
          email: email.trim(),
          name: name,
          studentId: studentId,
          role: studentData['role'] ?? 'student',
          cgpa: 0.0,
          section: studentData['section'] ?? '',
          semester: studentData['semester'] ?? 0,
          batch: studentData['batch'] ?? 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          metadata: {'loginMethod': 'email', 'registered': true},
        );

        await _firestoreService.createUserProfile(uid, newUser.toMap());

        // Step 5: Update the user state
        _user = newUser;
        _userData = newUser.toMap();
        _errorMessage = null;
        debugPrint('✓ Registration successful: $email');
      }
    } on fb.FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e.code);
      debugPrint('✗ Registration error [${e.code}]: ${e.message}');
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('✗ Registration error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login with Google
  Future<void> loginWithGoogle() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Initialize Google Sign-In
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize();

      // Sign out first to show account picker
      await googleSignIn.signOut();

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      // Create Firebase credential from Google sign-in
      final credential = fb.GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _firebaseService.auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final uid = userCredential.user!.uid;

        // Check if user profile exists
        var existingProfile = await _firestoreService.getUserProfile(uid);

        if (existingProfile == null) {
          // Create new profile for Google user (without student ID, needs verification later)
          final newUser = User(
            uid: uid,
            email: userCredential.user!.email ?? '',
            name: userCredential.user!.displayName ?? 'Google User',
            studentId: '', // Empty for OAuth users - needs to be added later
            role: 'student',
            cgpa: 0.0,
            section: '',
            semester: 0,
            batch: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            metadata: {'loginMethod': 'google', 'verified': false},
          );

          await _firestoreService.createUserProfile(uid, newUser.toMap());
          _user = newUser;
          _userData = newUser.toMap();
        } else {
          // Load existing profile
          await _loadUserProfile(uid);
        }

        debugPrint('✓ Google login successful: ${userCredential.user!.email}');
      }
    } on fb.FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e.code);
      debugPrint('✗ Google login error [${e.code}]: ${e.message}');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Google sign-in failed: $e';
      debugPrint('✗ Google login error: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login with GitHub (Placeholder - requires OAuth setup)
  Future<void> loginWithGitHub() async {
    _isLoading = true;
    _errorMessage = 'GitHub login coming soon. Please use Email or Google Sign-In.';
    debugPrint('⚠ GitHub login not yet configured');
    _isLoading = false;
    notifyListeners();
  }

  /// Logout
  Future<void> logout() async {
    _isLoading = true;
    try {
      await _firebaseService.signOut();
      _user = null;
      _userData = null;
      _errorMessage = null;
      debugPrint('✓ Logout successful');
    } catch (e) {
      _errorMessage = 'Logout failed: $e';
      debugPrint('✗ Logout error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    _isLoading = true;
    _errorMessage = null;

    try {
      await _firebaseService.auth.sendPasswordResetEmail(email: email.trim());
      _errorMessage = 'Password reset email sent to $email';
      debugPrint('✓ Password reset email sent to $email');
    } on fb.FirebaseAuthException catch (e) {
      _errorMessage = _getAuthErrorMessage(e.code);
      debugPrint('✗ Reset password error [${e.code}]: ${e.message}');
    } catch (e) {
      _errorMessage = 'Error: $e';
      debugPrint('✗ Reset password error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update user profile
  Future<void> updateProfile(Map<String, dynamic> updates) async {
    if (_user == null) return;

    try {
      await _firestoreService.updateUserProfile(_user!.uid, updates);

      // Update local state
      _user = _user!.copyWith(updatedAt: DateTime.now());
      _userData = _user!.toMap();
      _userData!.addAll(updates);
      notifyListeners();

      debugPrint('✓ Profile updated');
    } catch (e) {
      _errorMessage = 'Failed to update profile: $e';
      debugPrint('✗ Update profile error: $e');
      notifyListeners();
    }
  }

  /// Link student ID to existing account (for OAuth users)
  Future<bool> linkStudentId(String studentId) async {
    if (_user == null) {
      _errorMessage = 'No user logged in';
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Verify student ID exists
      bool studentExists = await _firestoreService.verifyStudentId(studentId);
      if (!studentExists) {
        _errorMessage = 'Student ID not found in system';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Get student ID data
      final studentData = await _firestoreService.getStudentIdData(studentId);
      if (studentData == null) {
        _errorMessage = 'Invalid student ID';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Update user profile with student ID and related info
      final updates = {
        'studentId': studentId,
        'section': studentData['section'] ?? '',
        'semester': studentData['semester'] ?? 0,
        'batch': studentData['batch'] ?? 0,
        'role': studentData['role'] ?? 'student',
        'metadata': {
          ..._user!.metadata,
          'verified': true,
        }
      };

      await _firestoreService.updateUserProfile(_user!.uid, updates);

      // Update local state
      _user = _user!.copyWith(
        studentId: studentId,
        section: studentData['section'] ?? '',
        semester: studentData['semester'] ?? 0,
        batch: studentData['batch'] ?? 0,
        role: studentData['role'] ?? 'student',
      );
      _userData = _user!.toMap();

      debugPrint('✓ Student ID linked: $studentId');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to link student ID: $e';
      debugPrint('✗ Link student ID error: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Get user-friendly error message from Firebase error code
  String _getAuthErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Email not registered. Please create an account.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'Email already registered. Please login instead.';
      case 'weak-password':
        return 'Password too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Invalid email format.';
      case 'operation-not-allowed':
        return 'Authentication is currently disabled.';
      case 'too-many-requests':
        return 'Too many login attempts. Try again in a few minutes.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with this email.';
      case 'invalid-credential':
        return 'Invalid credentials. Please try again.';
      default:
        return 'Authentication error: $code';
    }
  }
}
