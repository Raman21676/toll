import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String commentId;
  final String postId;
  final String userId;
  final String userName;
  final String? userProfileImage;
  final String content;
  final List<String> likes;
  final String? parentCommentId; // For nested replies
  final DateTime createdAt;
  final DateTime? updatedAt;

  Comment({
    required this.commentId,
    required this.postId,
    required this.userId,
    required this.userName,
    this.userProfileImage,
    required this.content,
    this.likes = const [],
    this.parentCommentId,
    required this.createdAt,
    this.updatedAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['commentId'] ?? '',
      postId: json['postId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userProfileImage: json['userProfileImage'],
      content: json['content'] ?? '',
      likes: List<String>.from(json['likes'] ?? []),
      parentCommentId: json['parentCommentId'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userProfileImage': userProfileImage,
      'content': content,
      'likes': likes,
      'parentCommentId': parentCommentId,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  int get likesCount => likes.length;
  bool isLikedBy(String userId) => likes.contains(userId);
  bool get isReply => parentCommentId != null;

  Comment copyWith({
    String? commentId,
    String? postId,
    String? userId,
    String? userName,
    String? userProfileImage,
    String? content,
    List<String>? likes,
    String? parentCommentId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Comment(
      commentId: commentId ?? this.commentId,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      content: content ?? this.content,
      likes: likes ?? this.likes,
      parentCommentId: parentCommentId ?? this.parentCommentId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
