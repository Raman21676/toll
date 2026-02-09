import 'dart:math';
import '../core/constants/app_constants.dart';
import '../models/janma_kundali_model.dart';
import '../models/planet_position_model.dart';
import '../models/chinaa_model.dart';

class AstrologyService {
  // Julian Day Number Calculation
  static double calculateJulianDay(DateTime dateTime) {
    int year = dateTime.year;
    int month = dateTime.month;
    int day = dateTime.day;
    double hour = dateTime.hour + dateTime.minute / 60.0 + dateTime.second / 3600.0;
    
    // If month is January or February, treat as 13th or 14th month of previous year
    if (month <= 2) {
      year -= 1;
      month += 12;
    }
    
    // Calculate Julian Day Number
    int A = (year / 100).floor();
    int B = 2 - A + (A / 4).floor();
    double JD = (365.25 * (year + 4716)).floor() +
        (30.6001 * (month + 1)).floor() +
        day + B - 1524.5;
    
    // Add time component
    JD += hour / 24.0;
    return JD;
  }
  
  // Lahiri Ayanamsa Calculation
  static double calculateLahiriAyanamsa(double julianDay) {
    double T = (julianDay - 2451545.0) / 36525.0; // Centuries since J2000
    
    // Lahiri Ayanamsa formula
    double ayanamsa = 22.460866 +
        (1.3969166 * T) +
        (0.000155 * T * T) -
        (0.00000333 * T * T * T);
    
    return ayanamsa;
  }
  
  // Convert Tropical to Sidereal
  static double tropicalToSidereal(double tropicalLongitude, double ayanamsa) {
    double siderealLongitude = (tropicalLongitude - ayanamsa) % 360;
    if (siderealLongitude < 0) {
      siderealLongitude += 360;
    }
    return siderealLongitude;
  }
  
  // Sun Position Calculation (Simplified)
  static double calculateSunLongitude(double julianDay) {
    double n = julianDay - 2451545.0;
    double L = (280.460 + 0.9856474 * n) % 360;
    double g = (357.528 + 0.9856003 * n) % 360;
    double gRad = g * pi / 180.0;
    double lambda = L + 1.915 * sin(gRad) + 0.020 * sin(2 * gRad);
    return lambda % 360;
  }
  
  // Moon Position Calculation (Simplified)
  static double calculateMoonLongitude(double julianDay) {
    double T = (julianDay - 2451545.0) / 36525.0;
    
    double Lp = (218.3164477 + 481267.88123421 * T) % 360;
    double Mp = (134.9633964 + 477198.8675055 * T) % 360;
    double MpRad = Mp * pi / 180.0;
    double M = (357.5291092 + 35999.0502909 * T) % 360;
    double MRad = M * pi / 180.0;
    double F = (93.2720950 + 483202.0175233 * T) % 360;
    double FRad = F * pi / 180.0;
    
    double moonLong = Lp +
        6.289 * sin(MpRad) +
        1.274 * sin(2 * MpRad - MRad) +
        0.658 * sin(2 * MpRad) +
        0.214 * sin(2 * MpRad) -
        0.186 * sin(MRad);
    
    return moonLong % 360;
  }
  
  // Calculate Rashi from Sidereal Longitude
  static Map<String, dynamic> getRashi(double siderealLongitude) {
    int rashiIndex = (siderealLongitude / 30).floor();
    String rashiName = AppConstants.rashiNames[rashiIndex];
    return {
      'name': rashiName,
      'number': rashiIndex + 1,
      'degreeInRashi': siderealLongitude % 30,
    };
  }
  
  // Calculate Nakshatra
  static Map<String, dynamic> getNakshatra(double moonLongitude) {
    double nakshatraSize = 360.0 / 27.0;
    int nakshatraIndex = (moonLongitude / nakshatraSize).floor();
    
    // Calculate pada (1-4)
    double positionInNakshatra = moonLongitude % nakshatraSize;
    int pada = (positionInNakshatra / (nakshatraSize / 4)).floor() + 1;
    
    final nakshatraData = AppConstants.nakshatras[nakshatraIndex];
    
    return {
      'name': nakshatraData['name'],
      'lord': nakshatraData['lord'],
      'number': nakshatraIndex + 1,
      'pada': pada,
    };
  }
  
  // Calculate Ascendant (Lagna)
  static double calculateLocalSiderealTime(double julianDay, double longitude) {
    double T = (julianDay - 2451545.0) / 36525.0;
    double GST = 280.46061837 +
        360.98564736629 * (julianDay - 2451545.0) +
        0.000387933 * T * T -
        T * T * T / 38710000.0;
    double LST = (GST + longitude) % 360;
    return LST;
  }
  
  static double calculateAscendant(double julianDay, double latitude, double longitude) {
    double LST = calculateLocalSiderealTime(julianDay, longitude);
    double latRad = latitude * pi / 180.0;
    double lstRad = LST * pi / 180.0;
    
    double ascendant = atan2(
      sin(lstRad),
      cos(lstRad) * sin(latRad) + tan(23.44 * pi / 180.0) * cos(latRad),
    );
    
    ascendant = ascendant * 180.0 / pi;
    if (ascendant < 0) ascendant += 360;
    
    return ascendant;
  }
  
  // Calculate House Number for a planet
  static int calculateHouseNumber(double planetPosition, double ascendant) {
    double difference = (planetPosition - ascendant + 360) % 360;
    int houseNumber = (difference / 30).floor() + 1;
    return houseNumber;
  }
  
  // Calculate Janma Kundali
  static JanmaKundali calculateJanmaKundali({
    required String userId,
    required DateTime birthDate,
    required DateTime birthTime,
    required String birthPlace,
    required double latitude,
    required double longitude,
  }) {
    // Create a datetime combining date and time
    final birthDateTime = DateTime(
      birthDate.year,
      birthDate.month,
      birthDate.day,
      birthTime.hour,
      birthTime.minute,
    );
    
    // Calculate Julian Day
    double jd = calculateJulianDay(birthDateTime);
    
    // Calculate Ayanamsa
    double ayanamsa = calculateLahiriAyanamsa(jd);
    
    // Calculate planetary positions
    double sunTropical = calculateSunLongitude(jd);
    double moonTropical = calculateMoonLongitude(jd);
    
    double sunSidereal = tropicalToSidereal(sunTropical, ayanamsa);
    double moonSidereal = tropicalToSidereal(moonTropical, ayanamsa);
    
    // Calculate Rashi and Nakshatra
    final rashiData = getRashi(moonSidereal);
    final nakshatraData = getNakshatra(moonSidereal);
    
    // Calculate Ascendant
    double ascendant = calculateAscendant(jd, latitude, longitude);
    final lagnaData = getRashi(ascendant);
    
    // Calculate Houses
    List<House> houses = [];
    for (int i = 0; i < 12; i++) {
      double houseStart = (ascendant + (30 * i)) % 360;
      double houseEnd = (houseStart + 30) % 360;
      final houseRashi = getRashi(houseStart);
      
      houses.add(House(
        houseNumber: i + 1,
        startDegree: houseStart,
        endDegree: houseEnd,
        rashi: houseRashi['name'],
        rashiNumber: houseRashi['number'],
        planets: [],
      ));
    }
    
    // Calculate planet positions
    Map<String, PlanetPosition> planets = {};
    
    // Sun
    planets['Sun'] = PlanetPosition(
      planet: 'Sun',
      longitude: sunSidereal,
      rashi: getRashi(sunSidereal)['name'],
      rashiNumber: getRashi(sunSidereal)['number'],
      house: calculateHouseNumber(sunSidereal, ascendant),
      degreeInRashi: sunSidereal % 30,
      nakshatra: getNakshatra(sunSidereal)['number'],
      pada: getNakshatra(sunSidereal)['pada'],
    );
    
    // Moon
    planets['Moon'] = PlanetPosition(
      planet: 'Moon',
      longitude: moonSidereal,
      rashi: rashiData['name'],
      rashiNumber: rashiData['number'],
      house: calculateHouseNumber(moonSidereal, ascendant),
      degreeInRashi: moonSidereal % 30,
      nakshatra: nakshatraData['number'],
      pada: nakshatraData['pada'],
    );
    
    // Other planets (simplified mean positions)
    final planetLongitudes = {
      'Mars': (355.45 + 19140.30 * ((jd - 2451545.0) / 36525.0)) % 360,
      'Mercury': (252.25 + 149472.68 * ((jd - 2451545.0) / 36525.0)) % 360,
      'Jupiter': (34.35 + 3034.91 * ((jd - 2451545.0) / 36525.0)) % 360,
      'Venus': (181.98 + 58517.82 * ((jd - 2451545.0) / 36525.0)) % 360,
      'Saturn': (50.08 + 1222.11 * ((jd - 2451545.0) / 36525.0)) % 360,
    };
    
    planetLongitudes.forEach((name, longitude) {
      double sidereal = tropicalToSidereal(longitude, ayanamsa);
      planets[name] = PlanetPosition(
        planet: name,
        longitude: sidereal,
        rashi: getRashi(sidereal)['name'],
        rashiNumber: getRashi(sidereal)['number'],
        house: calculateHouseNumber(sidereal, ascendant),
        degreeInRashi: sidereal % 30,
        nakshatra: getNakshatra(sidereal)['number'],
        pada: getNakshatra(sidereal)['pada'],
      );
    });
    
    // Rahu and Ketu (simplified)
    double rahuLongitude = (moonTropical - sunTropical + 180) % 360;
    double ketuLongitude = (rahuLongitude + 180) % 360;
    
    double rahuSidereal = tropicalToSidereal(rahuLongitude, ayanamsa);
    double ketuSidereal = tropicalToSidereal(ketuLongitude, ayanamsa);
    
    planets['Rahu'] = PlanetPosition(
      planet: 'Rahu',
      longitude: rahuSidereal,
      rashi: getRashi(rahuSidereal)['name'],
      rashiNumber: getRashi(rahuSidereal)['number'],
      house: calculateHouseNumber(rahuSidereal, ascendant),
      degreeInRashi: rahuSidereal % 30,
      nakshatra: getNakshatra(rahuSidereal)['number'],
      pada: getNakshatra(rahuSidereal)['pada'],
      retrograde: true,
    );
    
    planets['Ketu'] = PlanetPosition(
      planet: 'Ketu',
      longitude: ketuSidereal,
      rashi: getRashi(ketuSidereal)['name'],
      rashiNumber: getRashi(ketuSidereal)['number'],
      house: calculateHouseNumber(ketuSidereal, ascendant),
      degreeInRashi: ketuSidereal % 30,
      nakshatra: getNakshatra(ketuSidereal)['number'],
      pada: getNakshatra(ketuSidereal)['pada'],
      retrograde: true,
    );
    
    // Update houses with planets
    for (int i = 0; i < houses.length; i++) {
      List<String> housePlanets = [];
      planets.forEach((name, position) {
        if (position.house == i + 1) {
          housePlanets.add(name);
        }
      });
      houses[i] = House(
        houseNumber: houses[i].houseNumber,
        startDegree: houses[i].startDegree,
        endDegree: houses[i].endDegree,
        rashi: houses[i].rashi,
        rashiNumber: houses[i].rashiNumber,
        planets: housePlanets,
      );
    }
    
    // Check for Manglik Dosha
    final mars = planets['Mars'];
    bool isManglik = false;
    if (mars != null) {
      List<int> manglikHouses = [1, 4, 7, 8, 12];
      isManglik = manglikHouses.contains(mars.house);
    }
    
    return JanmaKundali(
      kundaliId: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      birthDate: birthDate,
      birthTime: birthTime,
      birthPlace: birthPlace,
      latitude: latitude,
      longitude: longitude,
      rashi: rashiData['name'],
      rashiNumber: rashiData['number'],
      nakshatra: nakshatraData['name'],
      nakshatraNumber: nakshatraData['number'],
      pada: nakshatraData['pada'],
      lagna: lagnaData['name'],
      lagnaNumber: lagnaData['number'],
      planets: planets,
      houses: houses,
      createdAt: DateTime.now(),
      doshas: {
        'manglik': isManglik,
        'manglikHouse': mars?.house,
      },
    );
  }
  
  // Calculate Gun Milan (Ashtakoot)
  static ChinaaMatch calculateGunMilan({
    required String user1Id,
    required String user2Id,
    required JanmaKundali kundali1,
    required JanmaKundali kundali2,
  }) {
    // Get nakshatras and rashis
    int boyNakshatra = kundali1.nakshatraNumber;
    int girlNakshatra = kundali2.nakshatraNumber;
    int boyRashi = kundali1.rashiNumber;
    int girlRashi = kundali2.rashiNumber;
    
    // 1. Varna (1 point)
    int varna = _calculateVarna(boyRashi, girlRashi);
    
    // 2. Vashya (2 points)
    int vashya = _calculateVashya(boyRashi, girlRashi);
    
    // 3. Tara/Dina (3 points)
    int tara = _calculateTara(boyNakshatra, girlNakshatra);
    
    // 4. Yoni (4 points)
    int yoni = _calculateYoni(boyNakshatra, girlNakshatra);
    
    // 5. Graha Maitri (5 points)
    int grahaMaitri = _calculateGrahaMaitri(boyRashi, girlRashi);
    
    // 6. Gana (6 points)
    int gana = _calculateGana(boyNakshatra, girlNakshatra);
    
    // 7. Bhakoot/Rashi (7 points)
    int bhakoot = _calculateBhakoot(boyRashi, girlRashi);
    
    // 8. Nadi (8 points)
    int nadi = _calculateNadi(boyNakshatra, girlNakshatra);
    
    int totalScore = varna + vashya + tara + yoni + grahaMaitri + gana + bhakoot + nadi;
    double percentage = (totalScore / 36) * 100;
    
    String compatibility;
    if (totalScore >= 32) {
      compatibility = 'Excellent (शुभ)';
    } else if (totalScore >= 24) {
      compatibility = 'Good (उत्तम)';
    } else if (totalScore >= 18) {
      compatibility = 'Average (मध्यम)';
    } else {
      compatibility = 'Poor (खराब)';
    }
    
    // Generate detailed report
    String report = _generateMatchReport(
      varna: varna,
      vashya: vashya,
      tara: tara,
      yoni: yoni,
      grahaMaitri: grahaMaitri,
      gana: gana,
      bhakoot: bhakoot,
      nadi: nadi,
      totalScore: totalScore,
      kundali1: kundali1,
      kundali2: kundali2,
    );
    
    return ChinaaMatch(
      matchId: '${user1Id}_${user2Id}_${DateTime.now().millisecondsSinceEpoch}',
      user1Id: user1Id,
      user2Id: user2Id,
      varna: varna,
      vashya: vashya,
      tara: tara,
      yoni: yoni,
      grahaMaitri: grahaMaitri,
      gana: gana,
      bhakoot: bhakoot,
      nadi: nadi,
      totalScore: totalScore,
      percentage: percentage,
      compatibility: compatibility,
      hasNadiDosha: nadi == 0,
      hasBhakootDosha: bhakoot == 0,
      user1Manglik: kundali1.doshas?['manglik'] ?? false,
      user2Manglik: kundali2.doshas?['manglik'] ?? false,
      detailedReport: report,
      createdAt: DateTime.now(),
    );
  }
  
  // Individual Gun Milan calculations
  static int _calculateVarna(int boyRashi, int girlRashi) {
    int boyVarna = AppConstants.rashiVarna[boyRashi] ?? 0;
    int girlVarna = AppConstants.rashiVarna[girlRashi] ?? 0;
    
    if (girlVarna <= boyVarna) {
      return 1;
    }
    return 0;
  }
  
  static int _calculateVashya(int boyRashi, int girlRashi) {
    final vashyaList = AppConstants.vashyaMap[boyRashi] ?? [];
    
    if (vashyaList.contains(girlRashi)) {
      return 2;
    } else if (boyRashi == girlRashi) {
      return 1;
    }
    return 0;
  }
  
  static int _calculateTara(int boyNakshatra, int girlNakshatra) {
    int count = ((girlNakshatra - boyNakshatra + 27) % 27);
    int taraGroup = (count % 9);
    
    List<int> favorable = [1, 3, 5, 7]; // janma, sampat, kshema, sadhana
    if (favorable.contains(taraGroup)) {
      return 3;
    } else if (taraGroup == 2 || taraGroup == 4) {
      return 1;
    }
    return 0;
  }
  
  static int _calculateYoni(int boyNakshatra, int girlNakshatra) {
    String boyYoni = AppConstants.nakshatraYoni[boyNakshatra] ?? '';
    String girlYoni = AppConstants.nakshatraYoni[girlNakshatra] ?? '';
    
    if (boyYoni == girlYoni) {
      return 4;
    } else if (AppConstants.yoniEnemies[boyYoni]?.contains(girlYoni) ?? false) {
      return 0;
    }
    return 2;
  }
  
  static int _calculateGrahaMaitri(int boyRashi, int girlRashi) {
    String boyLord = AppConstants.rashiLord[boyRashi] ?? '';
    String girlLord = AppConstants.rashiLord[girlRashi] ?? '';
    
    if (boyLord == girlLord) {
      return 5;
    } else if (AppConstants.planetaryFriends[boyLord]?.contains(girlLord) ?? false) {
      return 4;
    }
    return 1;
  }
  
  static int _calculateGana(int boyNakshatra, int girlNakshatra) {
    String boyGana = AppConstants.nakshatraGana[boyNakshatra] ?? '';
    String girlGana = AppConstants.nakshatraGana[girlNakshatra] ?? '';
    
    if (boyGana == girlGana) {
      return 6;
    } else if ((boyGana == 'Deva' && girlGana == 'Manushya') ||
        (boyGana == 'Manushya' && girlGana == 'Deva')) {
      return 5;
    } else if (boyGana == 'Manushya' && girlGana == 'Rakshasa') {
      return 1;
    }
    return 0;
  }
  
  static int _calculateBhakoot(int boyRashi, int girlRashi) {
    int count = ((girlRashi - boyRashi + 12) % 12);
    
    List<int> unfavorable = [2, 5, 6, 9, 12];
    if (boyRashi == girlRashi) {
      return 7;
    } else if (!unfavorable.contains(count)) {
      return 7;
    }
    return 0;
  }
  
  static int _calculateNadi(int boyNakshatra, int girlNakshatra) {
    String boyNadi = AppConstants.nakshatraNadi[boyNakshatra] ?? '';
    String girlNadi = AppConstants.nakshatraNadi[girlNakshatra] ?? '';
    
    if (boyNadi != girlNadi) {
      return 8;
    }
    return 0;
  }
  
  static String _generateMatchReport({
    required int varna,
    required int vashya,
    required int tara,
    required int yoni,
    required int grahaMaitri,
    required int gana,
    required int bhakoot,
    required int nadi,
    required int totalScore,
    required JanmaKundali kundali1,
    required JanmaKundali kundali2,
  }) {
    StringBuffer report = StringBuffer();
    
    report.writeln('=== CHINAA MATCHING REPORT ===\n');
    report.writeln('Total Gun Milan Score: $totalScore/36\n');
    
    report.writeln('--- Boy\'s Details ---');
    report.writeln('Rashi: ${kundali1.rashi}');
    report.writeln('Nakshatra: ${kundali1.nakshatra}, Pada ${kundali1.pada}');
    report.writeln('Manglik: ${kundali1.doshas?['manglik'] ?? false ? "Yes" : "No"}\n');
    
    report.writeln('--- Girl\'s Details ---');
    report.writeln('Rashi: ${kundali2.rashi}');
    report.writeln('Nakshatra: ${kundali2.nakshatra}, Pada ${kundali2.pada}');
    report.writeln('Manglik: ${kundali2.doshas?['manglik'] ?? false ? "Yes" : "No"}\n');
    
    report.writeln('--- Gun Milan Breakdown ---');
    report.writeln('1. Varna (Spiritual Development): $varna/1');
    report.writeln('2. Vashya (Mutual Attraction): $vashya/2');
    report.writeln('3. Tara (Birth Star Compatibility): $tara/3');
    report.writeln('4. Yoni (Animal Compatibility): $yoni/4');
    report.writeln('5. Graha Maitri (Planetary Friendship): $grahaMaitri/5');
    report.writeln('6. Gana (Temperament): $gana/6');
    report.writeln('7. Bhakoot (Sign Compatibility): $bhakoot/7');
    report.writeln('8. Nadi (Health & Progeny): $nadi/8\n');
    
    report.writeln('--- Dosha Analysis ---');
    if (nadi == 0) {
      report.writeln('⚠️ Nadi Dosha Present');
    } else {
      report.writeln('✓ No Nadi Dosha');
    }
    
    if (bhakoot == 0) {
      report.writeln('⚠️ Bhakoot Dosha Present');
    } else {
      report.writeln('✓ No Bhakoot Dosha');
    }
    
    if (kundali1.doshas?['manglik'] ?? false) {
      report.writeln('⚠️ Boy has Manglik Dosha');
    }
    if (kundali2.doshas?['manglik'] ?? false) {
      report.writeln('⚠️ Girl has Manglik Dosha');
    }
    
    report.writeln('\n--- Final Verdict ---');
    if (totalScore >= 32) {
      report.writeln('Excellent Match! Highly recommended.');
    } else if (totalScore >= 24) {
      report.writeln('Good Match! Can proceed with confidence.');
    } else if (totalScore >= 18) {
      report.writeln('Average Match. Consider other factors.');
    } else {
      report.writeln('Below average. Consult an expert astrologer.');
    }
    
    return report.toString();
  }
}
