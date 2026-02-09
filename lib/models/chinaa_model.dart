class ChinaaMatch {
  final String matchId;
  final String user1Id;
  final String user2Id;
  final int varna;
  final int vashya;
  final int tara;
  final int yoni;
  final int grahaMaitri;
  final int gana;
  final int bhakoot;
  final int nadi;
  final int totalScore;
  final double percentage;
  final String compatibility;
  final bool hasNadiDosha;
  final bool hasBhakootDosha;
  final bool user1Manglik;
  final bool user2Manglik;
  final List<DateTime> auspiciousDates;
  final String detailedReport;
  final DateTime createdAt;

  ChinaaMatch({
    required this.matchId,
    required this.user1Id,
    required this.user2Id,
    required this.varna,
    required this.vashya,
    required this.tara,
    required this.yoni,
    required this.grahaMaitri,
    required this.gana,
    required this.bhakoot,
    required this.nadi,
    required this.totalScore,
    required this.percentage,
    required this.compatibility,
    this.hasNadiDosha = false,
    this.hasBhakootDosha = false,
    this.user1Manglik = false,
    this.user2Manglik = false,
    this.auspiciousDates = const [],
    required this.detailedReport,
    required this.createdAt,
  });

  factory ChinaaMatch.fromJson(Map<String, dynamic> json) {
    return ChinaaMatch(
      matchId: json['matchId'] ?? '',
      user1Id: json['user1Id'] ?? '',
      user2Id: json['user2Id'] ?? '',
      varna: json['varna'] ?? 0,
      vashya: json['vashya'] ?? 0,
      tara: json['tara'] ?? 0,
      yoni: json['yoni'] ?? 0,
      grahaMaitri: json['grahaMaitri'] ?? 0,
      gana: json['gana'] ?? 0,
      bhakoot: json['bhakoot'] ?? 0,
      nadi: json['nadi'] ?? 0,
      totalScore: json['totalScore'] ?? 0,
      percentage: json['percentage']?.toDouble() ?? 0.0,
      compatibility: json['compatibility'] ?? '',
      hasNadiDosha: json['hasNadiDosha'] ?? false,
      hasBhakootDosha: json['hasBhakootDosha'] ?? false,
      user1Manglik: json['user1Manglik'] ?? false,
      user2Manglik: json['user2Manglik'] ?? false,
      auspiciousDates: [], // Will be populated separately
      detailedReport: json['detailedReport'] ?? '',
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'matchId': matchId,
      'user1Id': user1Id,
      'user2Id': user2Id,
      'varna': varna,
      'vashya': vashya,
      'tara': tara,
      'yoni': yoni,
      'grahaMaitri': grahaMaitri,
      'gana': gana,
      'bhakoot': bhakoot,
      'nadi': nadi,
      'totalScore': totalScore,
      'percentage': percentage,
      'compatibility': compatibility,
      'hasNadiDosha': hasNadiDosha,
      'hasBhakootDosha': hasBhakootDosha,
      'user1Manglik': user1Manglik,
      'user2Manglik': user2Manglik,
      'detailedReport': detailedReport,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class GunMilanBreakdown {
  final String name;
  final int maxPoints;
  final int obtained;
  final String description;

  GunMilanBreakdown({
    required this.name,
    required this.maxPoints,
    required this.obtained,
    required this.description,
  });
}
