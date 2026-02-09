import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String notificationId;
  final String userId; // Recipient
  final String senderId;
  final String senderName;
  final String? senderImageUrl;
  final NotificationType type;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.senderId,
    required this.senderName,
    this.senderImageUrl,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    this.isRead = false,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notificationId'] ?? '',
      userId: json['userId'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      senderImageUrl: json['senderImageUrl'],
      type: NotificationType.values.firstWhere(
        (e) => e.toString() == 'NotificationType.${json['type']}',
        orElse: () => NotificationType.other,
      ),
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      data: json['data'],
      isRead: json['isRead'] ?? false,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'userId': userId,
      'senderId': senderId,
      'senderName': senderName,
      'senderImageUrl': senderImageUrl,
      'type': type.toString().split('.').last,
      'title': title,
      'body': body,
      'data': data,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  NotificationModel copyWith({
    String? notificationId,
    String? userId,
    String? senderId,
    String? senderName,
    String? senderImageUrl,
    NotificationType? type,
    String? title,
    String? body,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      notificationId: notificationId ?? this.notificationId,
      userId: userId ?? this.userId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderImageUrl: senderImageUrl ?? this.senderImageUrl,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Factory constructors for common notification types
  static NotificationModel friendRequest({
    required String userId,
    required String senderId,
    required String senderName,
    String? senderImageUrl,
    required String requestId,
  }) {
    return NotificationModel(
      notificationId: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      senderId: senderId,
      senderName: senderName,
      senderImageUrl: senderImageUrl,
      type: NotificationType.friendRequest,
      title: 'New Friend Request',
      body: '$senderName sent you a friend request',
      data: {'requestId': requestId},
      createdAt: DateTime.now(),
    );
  }

  static NotificationModel friendRequestAccepted({
    required String userId,
    required String senderId,
    required String senderName,
    String? senderImageUrl,
  }) {
    return NotificationModel(
      notificationId: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      senderId: senderId,
      senderName: senderName,
      senderImageUrl: senderImageUrl,
      type: NotificationType.friendAccepted,
      title: 'Friend Request Accepted',
      body: '$senderName accepted your friend request',
      createdAt: DateTime.now(),
    );
  }

  static NotificationModel postLike({
    required String userId,
    required String senderId,
    required String senderName,
    String? senderImageUrl,
    required String postId,
  }) {
    return NotificationModel(
      notificationId: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      senderId: senderId,
      senderName: senderName,
      senderImageUrl: senderImageUrl,
      type: NotificationType.like,
      title: 'New Like',
      body: '$senderName liked your post',
      data: {'postId': postId},
      createdAt: DateTime.now(),
    );
  }

  static NotificationModel postComment({
    required String userId,
    required String senderId,
    required String senderName,
    String? senderImageUrl,
    required String postId,
    required String comment,
  }) {
    return NotificationModel(
      notificationId: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      senderId: senderId,
      senderName: senderName,
      senderImageUrl: senderImageUrl,
      type: NotificationType.comment,
      title: 'New Comment',
      body: '$senderName commented: $comment',
      data: {'postId': postId},
      createdAt: DateTime.now(),
    );
  }

  static NotificationModel newMessage({
    required String userId,
    required String senderId,
    required String senderName,
    String? senderImageUrl,
    required String chatRoomId,
    required String message,
  }) {
    return NotificationModel(
      notificationId: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      senderId: senderId,
      senderName: senderName,
      senderImageUrl: senderImageUrl,
      type: NotificationType.message,
      title: 'New Message',
      body: '$senderName: $message',
      data: {'chatRoomId': chatRoomId},
      createdAt: DateTime.now(),
    );
  }
}

enum NotificationType {
  friendRequest,
  friendAccepted,
  like,
  comment,
  message,
  mention,
  system,
  other,
}
