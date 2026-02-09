import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../models/janma_kundali_model.dart';
import 'astrology_service.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Search users with various filters
  Future<List<UserSearchResult>> searchUsers({
    String? query,
    List<String>? interests,
    List<String>? hobbies,
    String? rashi,
    int? minAge,
    int? maxAge,
    String? location,
    String? currentUserId,
    int limit = 20,
  }) async {
    try {
      Query<Map<String, dynamic>> firestoreQuery = _firestore
          .collection(AppConstants.usersCollection)
          .limit(limit);

      // Text search by name or nickname
      if (query != null && query.isNotEmpty) {
        // Note: Firestore doesn't support full-text search natively
        // For production, consider using Algolia or similar
        firestoreQuery = firestoreQuery
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name', isLessThanOrEqualTo: '$query\uf8ff');
      }

      final snapshot = await firestoreQuery.get();

      List<UserSearchResult> results = [];

      for (var doc in snapshot.docs) {
        final user = UserModel.fromJson(doc.data());
        
        // Skip current user
        if (user.uid == currentUserId) continue;

        // Apply client-side filters
        if (interests != null && interests.isNotEmpty) {
          final hasMatchingInterest = user.interests.any((i) => 
              interests.any((filter) => 
                  i.toLowerCase().contains(filter.toLowerCase())));
          if (!hasMatchingInterest) continue;
        }

        if (hobbies != null && hobbies.isNotEmpty) {
          final hasMatchingHobby = user.hobbies.any((h) => 
              hobbies.any((filter) => 
                  h.toLowerCase().contains(filter.toLowerCase())));
          if (!hasMatchingHobby) continue;
        }

        if (location != null && location.isNotEmpty) {
          if (user.address == null || 
              !user.address!.toLowerCase().contains(location.toLowerCase())) {
            continue;
          }
        }

        // Calculate compatibility if we have birth details
        double? compatibilityScore;
        if (user.birthDetails != null && currentUserId != null) {
          // Get current user's kundali
          final currentUserDoc = await _firestore
              .collection(AppConstants.usersCollection)
              .doc(currentUserId)
              .get();
          
          if (currentUserDoc.exists) {
            final currentUser = UserModel.fromJson(currentUserDoc.data()!);
            if (currentUser.birthDetails != null) {
              // Calculate compatibility
              compatibilityScore = await _calculateCompatibility(
                currentUser.birthDetails!,
                user.birthDetails!,
              );
            }
          }
        }

        results.add(UserSearchResult(
          user: user,
          compatibilityScore: compatibilityScore,
          commonInterests: _getCommonInterests(user.interests, interests ?? []),
          commonHobbies: _getCommonHobbies(user.hobbies, hobbies ?? []),
        ));
      }

      // Sort by compatibility score if available
      if (results.any((r) => r.compatibilityScore != null)) {
        results.sort((a, b) {
          final scoreA = a.compatibilityScore ?? 0;
          final scoreB = b.compatibilityScore ?? 0;
          return scoreB.compareTo(scoreA);
        });
      }

      return results;
    } catch (e) {
      debugPrint('Error searching users: $e');
      return [];
    }
  }

  /// Get users by interests
  Future<List<UserModel>> getUsersByInterests(
    List<String> interests, {
    String? excludeUserId,
    int limit = 20,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .where('interests', arrayContainsAny: interests)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .where((user) => user.uid != excludeUserId)
          .toList();
    } catch (e) {
      debugPrint('Error getting users by interests: $e');
      return [];
    }
  }

  /// Get users by Rashi (for astrology matching)
  Future<List<UserModel>> getUsersByRashi(
    String rashi, {
    String? excludeUserId,
    int limit = 20,
  }) async {
    try {
      // This requires storing rashi in user document
      // For now, we'll need to fetch kundalis and join
      final snapshot = await _firestore
          .collection(AppConstants.kundalisCollection)
          .where('rashi', isEqualTo: rashi)
          .limit(limit)
          .get();

      List<UserModel> users = [];
      for (var doc in snapshot.docs) {
        final kundali = JanmaKundali.fromJson(doc.data());
        if (kundali.userId == excludeUserId) continue;

        final userDoc = await _firestore
            .collection(AppConstants.usersCollection)
            .doc(kundali.userId)
            .get();

        if (userDoc.exists) {
          users.add(UserModel.fromJson(userDoc.data()!));
        }
      }

      return users;
    } catch (e) {
      debugPrint('Error getting users by rashi: $e');
      return [];
    }
  }

  /// Get recommended users based on compatibility
  Future<List<UserSearchResult>> getRecommendedUsers({
    required String currentUserId,
    required BirthDetails currentUserBirthDetails,
    int limit = 10,
  }) async {
    try {
      // Get users with birth details
      final snapshot = await _firestore
          .collection(AppConstants.usersCollection)
          .where('birthDetails', isNotEqualTo: null)
          .limit(limit * 2) // Get more to filter
          .get();

      List<UserSearchResult> results = [];

      for (var doc in snapshot.docs) {
        final user = UserModel.fromJson(doc.data());
        if (user.uid == currentUserId) continue;
        if (user.birthDetails == null) continue;

        final compatibilityScore = await _calculateCompatibility(
          currentUserBirthDetails,
          user.birthDetails!,
        );

        // Only include if compatibility is decent (> 18/36)
        if (compatibilityScore >= 50) {
          results.add(UserSearchResult(
            user: user,
            compatibilityScore: compatibilityScore,
          ));
        }
      }

      // Sort by compatibility
      results.sort((a, b) => 
        (b.compatibilityScore ?? 0).compareTo(a.compatibilityScore ?? 0));

      return results.take(limit).toList();
    } catch (e) {
      debugPrint('Error getting recommended users: $e');
      return [];
    }
  }

  /// Calculate compatibility between two users
  Future<double> _calculateCompatibility(
    BirthDetails user1Birth,
    BirthDetails user2Birth,
  ) async {
    try {
      // Generate kundalis for both users
      final kundali1 = AstrologyService.calculateJanmaKundali(
        userId: 'temp1',
        birthDate: user1Birth.birthDate,
        birthTime: user1Birth.birthTime,
        birthPlace: user1Birth.birthPlace,
        latitude: user1Birth.latitude ?? 27.7172, // Default to Kathmandu
        longitude: user1Birth.longitude ?? 85.3240,
      );

      final kundali2 = AstrologyService.calculateJanmaKundali(
        userId: 'temp2',
        birthDate: user2Birth.birthDate,
        birthTime: user2Birth.birthTime,
        birthPlace: user2Birth.birthPlace,
        latitude: user2Birth.latitude ?? 27.7172,
        longitude: user2Birth.longitude ?? 85.3240,
      );

      // Calculate Gun Milan
      final match = AstrologyService.calculateGunMilan(
        user1Id: 'temp1',
        user2Id: 'temp2',
        kundali1: kundali1,
        kundali2: kundali2,
      );

      return match.percentage;
    } catch (e) {
      debugPrint('Error calculating compatibility: $e');
      return 0;
    }
  }

  /// Get common interests count
  int _getCommonInterests(List<String> userInterests, List<String> filterInterests) {
    if (filterInterests.isEmpty) return 0;
    return userInterests.where((i) => 
        filterInterests.any((f) => i.toLowerCase() == f.toLowerCase())).length;
  }

  /// Get common hobbies count
  int _getCommonHobbies(List<String> userHobbies, List<String> filterHobbies) {
    if (filterHobbies.isEmpty) return 0;
    return userHobbies.where((h) => 
        filterHobbies.any((f) => h.toLowerCase() == f.toLowerCase())).length;
  }

  /// Stream of users for real-time updates
  Stream<List<UserModel>> streamAllUsers({int limit = 50}) {
    return _firestore
        .collection(AppConstants.usersCollection)
        .limit(limit)
        .snapshots()
        .map((snapshot) => 
            snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
  }
}

/// Search result wrapper with compatibility info
class UserSearchResult {
  final UserModel user;
  final double? compatibilityScore;
  final int commonInterests;
  final int commonHobbies;

  UserSearchResult({
    required this.user,
    this.compatibilityScore,
    this.commonInterests = 0,
    this.commonHobbies = 0,
  });

  String get compatibilityText {
    if (compatibilityScore == null) return 'Unknown';
    if (compatibilityScore! >= 80) return 'Excellent';
    if (compatibilityScore! >= 60) return 'Good';
    if (compatibilityScore! >= 40) return 'Average';
    return 'Low';
  }

  String get overallMatchScore {
    // Combine astrology compatibility with hobby/interest matching
    double score = compatibilityScore ?? 0;
    
    // Bonus for common interests
    score += (commonInterests * 2);
    score += (commonHobbies * 2);
    
    return score.clamp(0, 100).toStringAsFixed(0);
  }
}
