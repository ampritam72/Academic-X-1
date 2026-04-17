import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// Singleton Firebase Service
/// Centralized wrapper for all Firebase operations
class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();

  factory FirebaseService() {
    return _instance;
  }

  FirebaseService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Getters
  FirebaseAuth get auth => _auth;
  FirebaseFirestore get firestore => _firestore;

  // ============== Auth Methods ==============

  /// Get current authenticated user
  User? get currentUser => _auth.currentUser;

  /// Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  /// Get current user email
  String? get currentUserEmail => _auth.currentUser?.email;

  /// Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  /// Get auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      debugPrint('✓ User signed out');
    } catch (e) {
      debugPrint('✗ Sign out error: $e');
      rethrow;
    }
  }

  // ============== Firestore Methods ==============

  /// Verify if student ID exists in database
  Future<bool> verifyStudentId(String studentId) async {
    try {
      final doc = await _firestore
          .collection('student_id_map')
          .doc(studentId)
          .get();
      return doc.exists;
    } catch (e) {
      debugPrint('✗ Student ID verification error: $e');
      return false;
    }
  }

  /// Get student ID data
  Future<Map<String, dynamic>?> getStudentIdData(String studentId) async {
    try {
      final doc = await _firestore
          .collection('student_id_map')
          .doc(studentId)
          .get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      debugPrint('✗ Get student ID data error: $e');
      return null;
    }
  }

  /// Get user profile from Firestore
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      debugPrint('✗ Get user profile error: $e');
      return null;
    }
  }

  /// Create user profile in Firestore
  Future<void> createUserProfile(String uid, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(uid).set(userData);
      debugPrint('✓ User profile created: $uid');
    } catch (e) {
      debugPrint('✗ Create user profile error: $e');
      rethrow;
    }
  }

  /// Update user profile in Firestore
  Future<void> updateUserProfile(String uid, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('users').doc(uid).update(updates);
      debugPrint('✓ User profile updated: $uid');
    } catch (e) {
      debugPrint('✗ Update user profile error: $e');
      rethrow;
    }
  }

  /// Delete user profile
  Future<void> deleteUserProfile(String uid) async {
    try {
      await _firestore.collection('users').doc(uid).delete();
      debugPrint('✓ User profile deleted: $uid');
    } catch (e) {
      debugPrint('✗ Delete user profile error: $e');
      rethrow;
    }
  }

  /// Get reference to user document
  DocumentReference getUserRef(String uid) {
    return _firestore.collection('users').doc(uid);
  }

  /// Get reference to student_id_map collection
  CollectionReference getStudentIdMapRef() {
    return _firestore.collection('student_id_map');
  }

  /// Get reference to notices collection
  CollectionReference getNoticesRef() {
    return _firestore.collection('notices');
  }

  /// Get reference to routines collection
  CollectionReference getRoutinesRef() {
    return _firestore.collection('routines');
  }

  /// Get reference to chats collection
  CollectionReference getChatsRef() {
    return _firestore.collection('chats');
  }
}
