import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

/// Firestore Collection Management Service
/// Handles all Firestore collection operations
class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ============== User Profile Operations ==============

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

  /// Get user profile
  Future<User?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return User.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      debugPrint('✗ Get user profile error: $e');
      return null;
    }
  }

  /// Get user profile as map
  Future<Map<String, dynamic>?> getUserProfileMap(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      debugPrint('✗ Get user profile map error: $e');
      return null;
    }
  }

  /// Update user profile
  Future<void> updateUserProfile(String uid, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
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

  // ============== Student ID Verification ==============

  /// Verify if student ID exists
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

  /// Get student ID data with metadata
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

  /// Register student ID mapping
  Future<void> registerStudentId(
    String studentId, {
    required String uid,
    required String section,
    required int semester,
    required int batch,
    required String role,
  }) async {
    try {
      await _firestore.collection('student_id_map').doc(studentId).set({
        'uid': uid,
        'section': section,
        'semester': semester,
        'batch': batch,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
      debugPrint('✓ Student ID registered: $studentId');
    } catch (e) {
      debugPrint('✗ Register student ID error: $e');
      rethrow;
    }
  }

  // ============== Notice Operations ==============

  /// Get notices for a specific section
  Stream<List<Map<String, dynamic>>> getNoticesForSection(String section) {
    try {
      return _firestore
          .collection('notices')
          .where('section', isEqualTo: section)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => {
                      'id': doc.id,
                      ...doc.data(),
                    })
                .toList();
          });
    } catch (e) {
      debugPrint('✗ Get notices stream error: $e');
      return Stream.value([]);
    }
  }

  /// Get all notices for a user (section-based)
  Stream<List<Map<String, dynamic>>> getNoticesForUser(String section) {
    try {
      return _firestore
          .collection('notices')
          .where('section', isEqualTo: section)
          .orderBy('isImportant', descending: true)
          .orderBy('timestamp', descending: true)
          .limit(50)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => {
                      'id': doc.id,
                      ...doc.data(),
                    })
                .toList();
          });
    } catch (e) {
      debugPrint('✗ Get user notices stream error: $e');
      return Stream.value([]);
    }
  }

  /// Add a new notice
  Future<String> addNotice(Map<String, dynamic> noticeData) async {
    try {
      noticeData['timestamp'] = FieldValue.serverTimestamp();
      noticeData['createdAt'] = FieldValue.serverTimestamp();

      final docRef = await _firestore.collection('notices').add(noticeData);
      debugPrint('✓ Notice added: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      debugPrint('✗ Add notice error: $e');
      rethrow;
    }
  }

  /// Update a notice
  Future<void> updateNotice(String noticeId, Map<String, dynamic> updates) async {
    try {
      updates['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('notices').doc(noticeId).update(updates);
      debugPrint('✓ Notice updated: $noticeId');
    } catch (e) {
      debugPrint('✗ Update notice error: $e');
      rethrow;
    }
  }

  /// Delete a notice
  Future<void> deleteNotice(String noticeId) async {
    try {
      await _firestore.collection('notices').doc(noticeId).delete();
      debugPrint('✓ Notice deleted: $noticeId');
    } catch (e) {
      debugPrint('✗ Delete notice error: $e');
      rethrow;
    }
  }

  // ============== Routine Operations ==============

  /// Get routine for a section
  Future<Map<String, dynamic>?> getRoutineForSection(String section) async {
    try {
      final doc = await _firestore
          .collection('routines')
          .doc(section)
          .get();
      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      debugPrint('✗ Get routine error: $e');
      return null;
    }
  }

  // ============== Helper Methods ==============

  /// Batch get user data (profile + student ID info + section)
  Future<Map<String, dynamic>> getInitialUserData(String uid, String studentId) async {
    try {
      final userProfile = await getUserProfileMap(uid);
      final studentIdData = await getStudentIdData(studentId);

      return {
        'profile': userProfile,
        'studentData': studentIdData,
        'success': true,
      };
    } catch (e) {
      debugPrint('✗ Get initial user data error: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
