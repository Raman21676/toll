import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String postId;
  final String userId;
  final String userName;
  final String? userProfileImage;
  final String content;
  final List<String> imageUrls;
  final PostType type;
  final List<String> likes;
  final int commentsCount;
  final int sharesCount;
  final PostPrivacy privacy;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final List<String>? tags;
  final String? location;

  Post({
    required this.postId,
    required this.userId,
    required this.userName,
    this.userProfileImage,
    required this.content,
    this.imageUrls = const [],
    this.type = PostType.text,
    this.likes = const [],
    this.commentsCount = 0,
    this.sharesCount = 0,
    this.privacy = PostPrivacy.public,
    required this.createdAt,
    this.updatedAt,
    this.tags,
    this.location,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      postId: json['postId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userProfileImage: json['userProfileImage'],
      content: json['content'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      type: PostType.values.firstWhere(
        (e) => e.toString() == 'PostType.${json['type']}',
        orElse: () => PostType.text,
      ),
      likes: List<String>.from(json['likes'] ?? []),
      commentsCount: json['commentsCount'] ?? 0,
      sharesCount: json['sharesCount'] ?? 0,
      privacy: PostPrivacy.values.firstWhere(
        (e) => e.toString() == 'PostPrivacy.${json['privacy']}',
        orElse: () => PostPrivacy.public,
      ),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate(),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'userId': userId,
      'userName': userName,
      'userProfileImage': userProfileImage,
      'content': content,
      'imageUrls': imageUrls,
      'type': type.toString().split('.').last,
      'likes': likes,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'privacy': privacy.toString().split('.').last,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'tags': tags,
      'location': location,
    };
  }

  int get likesCount => likes.length;
  bool isLikedBy(String userId) => likes.contains(userId);

  Post copyWith({
    String? postId,
    String? userId,
    String? userName,
    String? userProfileImage,
    String? content,
    List<String>? imageUrls,
    PostType? type,
    List<String>? likes,
    int? commentsCount,
    int? sharesCount,
    PostPrivacy? privacy,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? tags,
    String? location,
  }) {
    return Post(
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userProfileImage: userProfileImage ?? this.userProfileImage,
      content: content ?? this.content,
      imageUrls: imageUrls ?? this.imageUrls,
      type: type ?? this.type,
      likes: likes ?? this.likes,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      privacy: privacy ?? this.privacy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      tags: tags ?? this.tags,
      location: location ?? this.location,
    );
  }
}

enum PostType {
  text,
  image,
  video,
  reel,
}

enum PostPrivacy {
  public,
  friends,
  private,
}
