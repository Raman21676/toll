import 'package:cloud_firestore/cloud_firestore.dart';

class Friendship {
  final String friendshipId;
  final String user1Id;
  final String user1Name;
  final String? user1ImageUrl;
  final String user2Id;
  final String user2Name;
  final String? user2ImageUrl;
  final DateTime createdAt;
  final DateTime? lastInteractionAt;
  final int? compatibilityScore;

  Friendship({
    required this.friendshipId,
    required this.user1Id,
    required this.user1Name,
    this.user1ImageUrl,
    required this.user2Id,
    required this.user2Name,
    this.user2ImageUrl,
    required this.createdAt,
    this.lastInteractionAt,
    this.compatibilityScore,
  });

  factory Friendship.fromJson(Map<String, dynamic> json) {
    return Friendship(
      friendshipId: json['friendshipId'] ?? '',
      user1Id: json['user1Id'] ?? '',
      user1Name: json['user1Name'] ?? '',
      user1ImageUrl: json['user1ImageUrl'],
      user2Id: json['user2Id'] ?? '',
      user2Name: json['user2Name'] ?? '',
      user2ImageUrl: json['user2ImageUrl'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastInteractionAt: (json['lastInteractionAt'] as Timestamp?)?.toDate(),
      compatibilityScore: json['compatibilityScore'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'friendshipId': friendshipId,
      'user1Id': user1Id,
      'user1Name': user1Name,
      'user1ImageUrl': user1ImageUrl,
      'user2Id': user2Id,
      'user2Name': user2Name,
      'user2ImageUrl': user2ImageUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastInteractionAt': lastInteractionAt != null 
          ? Timestamp.fromDate(lastInteractionAt!) 
          : null,
      'compatibilityScore': compatibilityScore,
    };
  }

  /// Get the other user's info given one user ID
  Map<String, dynamic> getOtherUserInfo(String currentUserId) {
    if (currentUserId == user1Id) {
      return {
        'uid': user2Id,
        'name': user2Name,
        'imageUrl': user2ImageUrl,
      };
    } else {
      return {
        'uid': user1Id,
        'name': user1Name,
        'imageUrl': user1ImageUrl,
      };
    }
  }

  Friendship copyWith({
    String? friendshipId,
    String? user1Id,
    String? user1Name,
    String? user1ImageUrl,
    String? user2Id,
    String? user2Name,
    String? user2ImageUrl,
    DateTime? createdAt,
    DateTime? lastInteractionAt,
    int? compatibilityScore,
  }) {
    return Friendship(
      friendshipId: friendshipId ?? this.friendshipId,
      user1Id: user1Id ?? this.user1Id,
      user1Name: user1Name ?? this.user1Name,
      user1ImageUrl: user1ImageUrl ?? this.user1ImageUrl,
      user2Id: user2Id ?? this.user2Id,
      user2Name: user2Name ?? this.user2Name,
      user2ImageUrl: user2ImageUrl ?? this.user2ImageUrl,
      createdAt: createdAt ?? this.createdAt,
      lastInteractionAt: lastInteractionAt ?? this.lastInteractionAt,
      compatibilityScore: compatibilityScore ?? this.compatibilityScore,
    );
  }
}
