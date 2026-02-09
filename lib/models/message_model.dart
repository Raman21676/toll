import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String messageId;
  final String chatRoomId;
  final String senderId;
  final String senderName;
  final String? senderImageUrl;
  final String text;
  final String? imageUrl;
  final MessageType type;
  final DateTime timestamp;
  final Map<String, bool> readBy;
  final bool isDeleted;
  final String? replyToMessageId;
  final String? replyToText;

  Message({
    required this.messageId,
    required this.chatRoomId,
    required this.senderId,
    required this.senderName,
    this.senderImageUrl,
    required this.text,
    this.imageUrl,
    this.type = MessageType.text,
    required this.timestamp,
    this.readBy = const {},
    this.isDeleted = false,
    this.replyToMessageId,
    this.replyToText,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['messageId'] ?? '',
      chatRoomId: json['chatRoomId'] ?? '',
      senderId: json['senderId'] ?? '',
      senderName: json['senderName'] ?? '',
      senderImageUrl: json['senderImageUrl'],
      text: json['text'] ?? '',
      imageUrl: json['imageUrl'],
      type: MessageType.values.firstWhere(
        (e) => e.toString() == 'MessageType.${json['type']}',
        orElse: () => MessageType.text,
      ),
      timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      readBy: Map<String, bool>.from(json['readBy'] ?? {}),
      isDeleted: json['isDeleted'] ?? false,
      replyToMessageId: json['replyToMessageId'],
      replyToText: json['replyToText'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'senderName': senderName,
      'senderImageUrl': senderImageUrl,
      'text': text,
      'imageUrl': imageUrl,
      'type': type.toString().split('.').last,
      'timestamp': Timestamp.fromDate(timestamp),
      'readBy': readBy,
      'isDeleted': isDeleted,
      'replyToMessageId': replyToMessageId,
      'replyToText': replyToText,
    };
  }

  bool isReadBy(String userId) => readBy[userId] ?? false;
  bool get isImage => type == MessageType.image;
  bool get isText => type == MessageType.text;
  bool get isEmoji => type == MessageType.emoji;
  bool get isReply => replyToMessageId != null;

  Message copyWith({
    String? messageId,
    String? chatRoomId,
    String? senderId,
    String? senderName,
    String? senderImageUrl,
    String? text,
    String? imageUrl,
    MessageType? type,
    DateTime? timestamp,
    Map<String, bool>? readBy,
    bool? isDeleted,
    String? replyToMessageId,
    String? replyToText,
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      senderImageUrl: senderImageUrl ?? this.senderImageUrl,
      text: text ?? this.text,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      readBy: readBy ?? this.readBy,
      isDeleted: isDeleted ?? this.isDeleted,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      replyToText: replyToText ?? this.replyToText,
    );
  }

  /// Create a text message
  static Message createTextMessage({
    required String chatRoomId,
    required String senderId,
    required String senderName,
    String? senderImageUrl,
    required String text,
    String? replyToMessageId,
    String? replyToText,
  }) {
    return Message(
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      chatRoomId: chatRoomId,
      senderId: senderId,
      senderName: senderName,
      senderImageUrl: senderImageUrl,
      text: text,
      type: MessageType.text,
      timestamp: DateTime.now(),
      replyToMessageId: replyToMessageId,
      replyToText: replyToText,
    );
  }

  /// Create an image message
  static Message createImageMessage({
    required String chatRoomId,
    required String senderId,
    required String senderName,
    String? senderImageUrl,
    required String imageUrl,
    String? caption,
  }) {
    return Message(
      messageId: DateTime.now().millisecondsSinceEpoch.toString(),
      chatRoomId: chatRoomId,
      senderId: senderId,
      senderName: senderName,
      senderImageUrl: senderImageUrl,
      text: caption ?? '',
      imageUrl: imageUrl,
      type: MessageType.image,
      timestamp: DateTime.now(),
    );
  }
}

enum MessageType {
  text,
  image,
  emoji,
  system,
}
