import 'package:cloud_firestore/cloud_firestore.dart';

class BirthDetails {
  final DateTime birthDate;
  final DateTime birthTime;
  final String birthPlace;
  final double? latitude;
  final double? longitude;
  final String? timezone;
  final bool birthTimeUnknown;

  BirthDetails({
    required this.birthDate,
    required this.birthTime,
    required this.birthPlace,
    this.latitude,
    this.longitude,
    this.timezone,
    this.birthTimeUnknown = false,
  });

  factory BirthDetails.fromJson(Map<String, dynamic> json) {
    return BirthDetails(
      birthDate: (json['birthDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      birthTime: (json['birthTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      birthPlace: json['birthPlace'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      timezone: json['timezone'],
      birthTimeUnknown: json['birthTimeUnknown'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'birthDate': Timestamp.fromDate(birthDate),
      'birthTime': Timestamp.fromDate(birthTime),
      'birthPlace': birthPlace,
      'latitude': latitude,
      'longitude': longitude,
      'timezone': timezone,
      'birthTimeUnknown': birthTimeUnknown,
    };
  }

  BirthDetails copyWith({
    DateTime? birthDate,
    DateTime? birthTime,
    String? birthPlace,
    double? latitude,
    double? longitude,
    String? timezone,
    bool? birthTimeUnknown,
  }) {
    return BirthDetails(
      birthDate: birthDate ?? this.birthDate,
      birthTime: birthTime ?? this.birthTime,
      birthPlace: birthPlace ?? this.birthPlace,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      timezone: timezone ?? this.timezone,
      birthTimeUnknown: birthTimeUnknown ?? this.birthTimeUnknown,
    );
  }
}
