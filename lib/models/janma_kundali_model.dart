import 'package:cloud_firestore/cloud_firestore.dart';
import 'planet_position_model.dart';

class JanmaKundali {
  final String kundaliId;
  final String userId;
  final DateTime birthDate;
  final DateTime birthTime;
  final String birthPlace;
  final double latitude;
  final double longitude;
  final String rashi;
  final int rashiNumber;
  final String nakshatra;
  final int nakshatraNumber;
  final int pada;
  final String lagna;
  final int lagnaNumber;
  final Map<String, PlanetPosition> planets;
  final List<House> houses;
  final DateTime createdAt;
  final Map<String, dynamic>? doshas;

  JanmaKundali({
    required this.kundaliId,
    required this.userId,
    required this.birthDate,
    required this.birthTime,
    required this.birthPlace,
    required this.latitude,
    required this.longitude,
    required this.rashi,
    required this.rashiNumber,
    required this.nakshatra,
    required this.nakshatraNumber,
    required this.pada,
    required this.lagna,
    required this.lagnaNumber,
    required this.planets,
    required this.houses,
    required this.createdAt,
    this.doshas,
  });

  factory JanmaKundali.fromJson(Map<String, dynamic> json) {
    final planetsJson = json['planets'] as Map<String, dynamic>? ?? {};
    final planets = planetsJson.map((key, value) => 
      MapEntry(key, PlanetPosition.fromJson(value as Map<String, dynamic>)));
    
    final housesJson = json['houses'] as List<dynamic>? ?? [];
    final houses = housesJson.map((h) => House.fromJson(h as Map<String, dynamic>)).toList();

    return JanmaKundali(
      kundaliId: json['kundaliId'] ?? '',
      userId: json['userId'] ?? '',
      birthDate: (json['birthDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      birthTime: (json['birthTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      birthPlace: json['birthPlace'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      rashi: json['rashi'] ?? '',
      rashiNumber: json['rashiNumber'] ?? 1,
      nakshatra: json['nakshatra'] ?? '',
      nakshatraNumber: json['nakshatraNumber'] ?? 1,
      pada: json['pada'] ?? 1,
      lagna: json['lagna'] ?? '',
      lagnaNumber: json['lagnaNumber'] ?? 1,
      planets: planets,
      houses: houses,
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      doshas: json['doshas'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kundaliId': kundaliId,
      'userId': userId,
      'birthDate': Timestamp.fromDate(birthDate),
      'birthTime': Timestamp.fromDate(birthTime),
      'birthPlace': birthPlace,
      'latitude': latitude,
      'longitude': longitude,
      'rashi': rashi,
      'rashiNumber': rashiNumber,
      'nakshatra': nakshatra,
      'nakshatraNumber': nakshatraNumber,
      'pada': pada,
      'lagna': lagna,
      'lagnaNumber': lagnaNumber,
      'planets': planets.map((key, value) => MapEntry(key, value.toJson())),
      'houses': houses.map((h) => h.toJson()).toList(),
      'createdAt': Timestamp.fromDate(createdAt),
      'doshas': doshas,
    };
  }
}

class House {
  final int houseNumber;
  final double startDegree;
  final double endDegree;
  final String rashi;
  final int rashiNumber;
  final List<String> planets;

  House({
    required this.houseNumber,
    required this.startDegree,
    required this.endDegree,
    required this.rashi,
    required this.rashiNumber,
    this.planets = const [],
  });

  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      houseNumber: json['houseNumber'] ?? 1,
      startDegree: json['startDegree']?.toDouble() ?? 0.0,
      endDegree: json['endDegree']?.toDouble() ?? 0.0,
      rashi: json['rashi'] ?? '',
      rashiNumber: json['rashiNumber'] ?? 1,
      planets: List<String>.from(json['planets'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'houseNumber': houseNumber,
      'startDegree': startDegree,
      'endDegree': endDegree,
      'rashi': rashi,
      'rashiNumber': rashiNumber,
      'planets': planets,
    };
  }
}
