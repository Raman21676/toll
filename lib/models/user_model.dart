import 'package:cloud_firestore/cloud_firestore.dart';
import 'birth_details_model.dart';

class UserModel {
  final String uid;
  final String name;
  final String nickname;
  final String email;
  final String? phoneNumber;
  final String? address;
  final String? profileImageUrl;
  final List<String> interests;
  final List<String> hobbies;
  final BirthDetails? birthDetails;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isOnline;
  final DateTime? lastSeen;
  final String? kundaliId;

  UserModel({
    required this.uid,
    required this.name,
    required this.nickname,
    required this.email,
    this.phoneNumber,
    this.address,
    this.profileImageUrl,
    this.interests = const [],
    this.hobbies = const [],
    this.birthDetails,
    required this.createdAt,
    required this.updatedAt,
    this.isOnline = false,
    this.lastSeen,
    this.kundaliId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      nickname: json['nickname'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      address: json['address'],
      profileImageUrl: json['profileImageUrl'],
      interests: List<String>.from(json['interests'] ?? []),
      hobbies: List<String>.from(json['hobbies'] ?? []),
      birthDetails: json['birthDetails'] != null
          ? BirthDetails.fromJson(json['birthDetails'])
          : null,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (json['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isOnline: json['isOnline'] ?? false,
      lastSeen: (json['lastSeen'] as Timestamp?)?.toDate(),
      kundaliId: json['kundaliId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'nickname': nickname,
      'email': email,
      'phoneNumber': phoneNumber,
      'address': address,
      'profileImageUrl': profileImageUrl,
      'interests': interests,
      'hobbies': hobbies,
      'birthDetails': birthDetails?.toJson(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isOnline': isOnline,
      'lastSeen': lastSeen != null ? Timestamp.fromDate(lastSeen!) : null,
      'kundaliId': kundaliId,
    };
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? nickname,
    String? email,
    String? phoneNumber,
    String? address,
    String? profileImageUrl,
    List<String>? interests,
    List<String>? hobbies,
    BirthDetails? birthDetails,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isOnline,
    DateTime? lastSeen,
    String? kundaliId,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      interests: interests ?? this.interests,
      hobbies: hobbies ?? this.hobbies,
      birthDetails: birthDetails ?? this.birthDetails,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      kundaliId: kundaliId ?? this.kundaliId,
    );
  }
}
