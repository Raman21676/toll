import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  final String chatRoomId;
  final List<String> participants;
  final Map<String, ParticipantInfo> participantInfo;
  final String lastMessage;
  final String? lastMessageSenderId;
  final DateTime? lastMessageTime;
  final Map<String, int> unreadCount;
  final DateTime createdAt;

  ChatRoom({
    required this.chatRoomId,
    required this.participants,
    required this.participantInfo,
    this.lastMessage = '',
    this.lastMessageSenderId,
    this.lastMessageTime,
    this.unreadCount = const {},
    required this.createdAt,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    final participantInfoJson = json['participantInfo'] as Map<String, dynamic>? ?? {};
    final participantInfo = participantInfoJson.map((key, value) => 
      MapEntry(key, ParticipantInfo.fromJson(value as Map<String, dynamic>)));

    return ChatRoom(
      chatRoomId: json['chatRoomId'] ?? '',
      participants: List<String>.from(json['participants'] ?? []),
      participantInfo: participantInfo,
      lastMessage: json['lastMessage'] ?? '',
      lastMessageSenderId: json['lastMessageSenderId'],
      lastMessageTime: (json['lastMessageTime'] as Timestamp?)?.toDate(),
      unreadCount: Map<String, int>.from(json['unreadCount'] ?? {}),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatRoomId': chatRoomId,
      'participants': participants,
      'participantInfo': participantInfo.map((key, value) => MapEntry(key, value.toJson())),
      'lastMessage': lastMessage,
      'lastMessageSenderId': lastMessageSenderId,
      'lastMessageTime': lastMessageTime != null ? Timestamp.fromDate(lastMessageTime!) : null,
      'unreadCount': unreadCount,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  /// Get the other participant's info for a 1-on-1 chat
  ParticipantInfo? getOtherParticipantInfo(String currentUserId) {
    for (var entry in participantInfo.entries) {
      if (entry.key != currentUserId) {
        return entry.value;
      }
    }
    return null;
  }

  /// Get unread count for a specific user
  int getUnreadCount(String userId) {
    return unreadCount[userId] ?? 0;
  }

  /// Check if user has unread messages
  bool hasUnread(String userId) {
    return (unreadCount[userId] ?? 0) > 0;
  }

  ChatRoom copyWith({
    String? chatRoomId,
    List<String>? participants,
    Map<String, ParticipantInfo>? participantInfo,
    String? lastMessage,
    String? lastMessageSenderId,
    DateTime? lastMessageTime,
    Map<String, int>? unreadCount,
    DateTime? createdAt,
  }) {
    return ChatRoom(
      chatRoomId: chatRoomId ?? this.chatRoomId,
      participants: participants ?? this.participants,
      participantInfo: participantInfo ?? this.participantInfo,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageSenderId: lastMessageSenderId ?? this.lastMessageSenderId,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Create a chat room ID from two user IDs (consistent ordering)
  static String createChatRoomId(String userId1, String userId2) {
    final sortedIds = [userId1, userId2]..sort();
    return '${sortedIds[0]}_${sortedIds[1]}';
  }
}

class ParticipantInfo {
  final String userId;
  final String name;
  final String? imageUrl;
  final bool isOnline;
  final DateTime? lastSeen;

  ParticipantInfo({
    required this.userId,
    required this.name,
    this.imageUrl,
    this.isOnline = false,
    this.lastSeen,
  });

  factory ParticipantInfo.fromJson(Map<String, dynamic> json) {
    return ParticipantInfo(
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'],
      isOnline: json['isOnline'] ?? false,
      lastSeen: (json['lastSeen'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'imageUrl': imageUrl,
      'isOnline': isOnline,
      'lastSeen': lastSeen != null ? Timestamp.fromDate(lastSeen!) : null,
    };
  }

  ParticipantInfo copyWith({
    String? userId,
    String? name,
    String? imageUrl,
    bool? isOnline,
    DateTime? lastSeen,
  }) {
    return ParticipantInfo(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }
}
