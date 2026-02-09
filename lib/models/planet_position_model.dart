class PlanetPosition {
  final String planet;
  final double longitude;
  final double latitude;
  final double distance;
  final double speed;
  final String rashi;
  final int rashiNumber;
  final int house;
  final bool retrograde;
  final double degreeInRashi;
  final int nakshatra;
  final int pada;

  PlanetPosition({
    required this.planet,
    required this.longitude,
    this.latitude = 0.0,
    this.distance = 0.0,
    this.speed = 0.0,
    required this.rashi,
    required this.rashiNumber,
    required this.house,
    this.retrograde = false,
    required this.degreeInRashi,
    required this.nakshatra,
    required this.pada,
  });

  factory PlanetPosition.fromJson(Map<String, dynamic> json) {
    return PlanetPosition(
      planet: json['planet'] ?? '',
      longitude: json['longitude']?.toDouble() ?? 0.0,
      latitude: json['latitude']?.toDouble() ?? 0.0,
      distance: json['distance']?.toDouble() ?? 0.0,
      speed: json['speed']?.toDouble() ?? 0.0,
      rashi: json['rashi'] ?? '',
      rashiNumber: json['rashiNumber'] ?? 1,
      house: json['house'] ?? 1,
      retrograde: json['retrograde'] ?? false,
      degreeInRashi: json['degreeInRashi']?.toDouble() ?? 0.0,
      nakshatra: json['nakshatra'] ?? 1,
      pada: json['pada'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planet': planet,
      'longitude': longitude,
      'latitude': latitude,
      'distance': distance,
      'speed': speed,
      'rashi': rashi,
      'rashiNumber': rashiNumber,
      'house': house,
      'retrograde': retrograde,
      'degreeInRashi': degreeInRashi,
      'nakshatra': nakshatra,
      'pada': pada,
    };
  }
}
