import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';

class UserService with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  // Create user profile
  Future<Map<String, dynamic>> createUserProfile(UserModel user) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .set(user.toJson());
      
      _currentUser = user;
      _isLoading = false;
      notifyListeners();
      
      return {
        'success': true,
        'message': 'Profile created successfully',
      };
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'error': 'Failed to create profile: $e',
      };
    }
  }
  
  // Get user profile
  Future<Map<String, dynamic>> getUserProfile(String uid) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .get();
      
      _isLoading = false;
      notifyListeners();
      
      if (doc.exists && doc.data() != null) {
        final user = UserModel.fromJson(doc.data()!);
        if (uid == _currentUser?.uid) {
          _currentUser = user;
          notifyListeners();
        }
        return {
          'success': true,
          'user': user,
        };
      }
      
      return {
        'success': false,
        'error': 'User not found',
      };
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'error': 'Failed to fetch profile: $e',
      };
    }
  }
  
  // Update user profile
  Future<Map<String, dynamic>> updateUserProfile({
    required String uid,
    String? name,
    String? nickname,
    String? phoneNumber,
    String? address,
    String? profileImageUrl,
    List<String>? interests,
    List<String>? hobbies,
    Map<String, dynamic>? birthDetails,
    String? kundaliId,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final Map<String, dynamic> updates = {
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      };
      
      if (name != null) updates['name'] = name;
      if (nickname != null) updates['nickname'] = nickname;
      if (phoneNumber != null) updates['phoneNumber'] = phoneNumber;
      if (address != null) updates['address'] = address;
      if (profileImageUrl != null) updates['profileImageUrl'] = profileImageUrl;
      if (interests != null) updates['interests'] = interests;
      if (hobbies != null) updates['hobbies'] = hobbies;
      if (birthDetails != null) updates['birthDetails'] = birthDetails;
      if (kundaliId != null) updates['kundaliId'] = kundaliId;
      
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .update(updates);
      
      // Refresh current user data
      if (uid == _currentUser?.uid) {
        await getUserProfile(uid);
      }
      
      _isLoading = false;
      notifyListeners();
      
      return {
        'success': true,
        'message': 'Profile updated successfully',
      };
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {
        'success': false,
        'error': 'Failed to update profile: $e',
      };
    }
  }
  
  // Set user online status
  Future<void> setUserOnline(String uid, bool isOnline) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(uid)
          .update({
        'isOnline': isOnline,
        'lastSeen': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      debugPrint('Error updating online status: $e');
    }
  }
  
  // Search users
  Future<List<UserModel>> searchUsers({
    String? query,
    List<String>? interests,
    String? rashi,
    int limit = 20,
  }) async {
    try {
      Query<Map<String, dynamic>> firestoreQuery = _firestore
          .collection(AppConstants.usersCollection)
          .limit(limit);
      
      if (query != null && query.isNotEmpty) {
        // Search by name or nickname
        firestoreQuery = firestoreQuery
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThanOrEqualTo: '$query\uf8ff');
      }
      
      final snapshot = await firestoreQuery.get();
      
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .where((user) {
        // Filter by interests if specified
        if (interests != null && interests.isNotEmpty) {
          final hasMatchingInterest = user.interests
              .any((i) => interests.any((filter) => 
                  i.toLowerCase().contains(filter.toLowerCase())));
          if (!hasMatchingInterest) return false;
        }
        return true;
      })
      .toList();
    } catch (e) {
      debugPrint('Error searching users: $e');
      return [];
    }
  }
  
  // Get all users (for admin/testing)
  Future<List<UserModel>> getAllUsers({int limit = 50}) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .limit(limit)
          .get();
      
      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      debugPrint('Error getting users: $e');
      return [];
    }
  }
  
  // Stream user profile for real-time updates
  Stream<UserModel?> streamUserProfile(String uid) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .doc(uid)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
      return null;
    });
  }
  
  // Clear current user (on logout)
  void clearCurrentUser() {
    _currentUser = null;
    notifyListeners();
  }
}
