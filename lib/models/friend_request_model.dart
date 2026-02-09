import 'package:cloud_firestore/cloud_firestore.dart';

class FriendRequest {
  final String requestId;
  final String senderId;
  final String senderName;
  final String? senderImageUrl;
  final String receiverId;
  final String receiverName;
  final String? receiverImageUrl;
  final FriendRequestStatus status;
  final DateTime sentAt;
  final DateTime? respondedAt;
  final String? message;

  FriendRequest({
    required this.requestId,
    required this.senderId,
    required this.senderName,
    this.senderImageUrl,
    required this.receiverId,
    required this.receiverName,
    this.receiverImageUrl,
    this.status = FriendRequestStatus.pending,
    required this.sentAt,
    this.respondedAt,
    this.message,
  });

  factory FriendRequest.fromJson(Map<String, dynamic> json) {
    return FriendRequest(
      requestId: json['requestId'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      senderImageUrl: json['senderImageUrl'],
      receiverId: json['receiverId'] ?? '',
      receiverName: json['receiverName'] ?? '',
      receiverImageUrl: json['receiverImageUrl'],
      status: FriendRequestStatus.values.firstWhere(
        (e) => e.toString() == 'FriendRequestStatus.${json['status']}',
        orElse: () => FriendRequestStatus.pending,
      ),
      sentAt: (json['sentAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      respondedAt: (json['respondedAt'] as Timestamp?)?.toDate(),
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'senderId': senderId,
      'senderName': senderName,
      'senderImageUrl': senderImageUrl,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'receiverImageUrl': receiverImageUrl,
      'status': status.toString().split('.').last,
      'sentAt': Timestamp.fromDate(sentAt),
      'respondedAt': respondedAt != null ? Timestamp.fromDate(respondedAt!) : null,
      'message': message,
    };
  }

  FriendRequest copyWith({
    String? requestId,
    String? senderId,
    String? senderName,
    String? senderImageUrl,
    String? receiverId,
    String? receiverName,
    String? receiverImageUrl,
    FriendRequestStatus? status,
    DateTime? sentAt,
    DateTime? respondedAt,
    String? message,
  }) {
    return FriendRequest(
      requestId: requestId ?? this.requestId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderImageUrl: senderImageUrl ?? this.senderImageUrl,
      receiverId: receiverId ?? this.receiverId,
      receiverName: receiverName ?? this.receiverName,
      receiverImageUrl: receiverImageUrl ?? this.receiverImageUrl,
      status: status ?? this.status,
      sentAt: sentAt ?? this.sentAt,
      respondedAt: respondedAt ?? this.respondedAt,
      message: message ?? this.message,
    );
  }

  bool get isPending => status == FriendRequestStatus.pending;
  bool get isAccepted => status == FriendRequestStatus.accepted;
  bool get isRejected => status == FriendRequestStatus.rejected;
  bool get isCancelled => status == FriendRequestStatus.cancelled;
}

enum FriendRequestStatus {
  pending,
  accepted,
  rejected,
  cancelled,
}
