class AppConstants {
  // App Info
  static const String appName = 'AstroConnect';
  static const String appVersion = '1.0.0';
  
  // Collection Names
  static const String usersCollection = 'users';
  static const String kundalisCollection = 'kundalis';
  static const String matchesCollection = 'matches';
  static const String friendRequestsCollection = 'friend_requests';
  static const String friendshipsCollection = 'friendships';
  static const String postsCollection = 'posts';
  static const String chatsCollection = 'chats';
  static const String messagesCollection = 'messages';
  static const String notificationsCollection = 'notifications';
  
  // Interests List
  static const List<String> predefinedInterests = [
    'Astrology',
    'Vedic Science',
    'Spirituality',
    'Meditation',
    'Yoga',
    'Temple Visiting',
    'Festival Celebrations',
    'Horoscope Reading',
    'Palmistry',
    'Vastu Shastra',
    'Numerology',
    'Tarot Reading',
    'Hindu Mythology',
    'Classical Music',
    'Traditional Dance',
    'Cooking',
    'Traveling',
    'Photography',
    'Reading',
    'Sports',
    'Fitness',
    'Movies',
    'Music',
    'Art',
    'Technology',
    'Business',
    'Education',
    'Social Service',
  ];
  
  // Hobbies List
  static const List<String> predefinedHobbies = [
    'Reading Books',
    'Listening to Music',
    'Watching Movies',
    'Playing Sports',
    'Cooking',
    'Gardening',
    'Photography',
    'Traveling',
    'Painting',
    'Writing',
    'Dancing',
    'Singing',
    'Playing Instruments',
    'Video Gaming',
    'Hiking',
    'Cycling',
    'Swimming',
    'Yoga',
    'Meditation',
    'Astrology Study',
    'Puja/ prayers',
    'Visiting Temples',
    'Volunteering',
    'Social Media',
    'Blogging',
    'Shopping',
    'Collecting Items',
    'Bird Watching',
    'Stargazing',
  ];
  
  // Rashi Names
  static const List<String> rashiNames = [
    'Mesha (Aries)',      // 0° - 30°
    'Vrishabha (Taurus)', // 30° - 60°
    'Mithuna (Gemini)',   // 60° - 90°
    'Karka (Cancer)',     // 90° - 120°
    'Simha (Leo)',        // 120° - 150°
    'Kanya (Virgo)',      // 150° - 180°
    'Tula (Libra)',       // 180° - 210°
    'Vrishchika (Scorpio)', // 210° - 240°
    'Dhanu (Sagittarius)', // 240° - 270°
    'Makara (Capricorn)', // 270° - 300°
    'Kumbha (Aquarius)',  // 300° - 330°
    'Meena (Pisces)',     // 330° - 360°
  ];
  
  // Nakshatra Names
  static const List<Map<String, dynamic>> nakshatras = [
    {'name': 'Ashwini', 'lord': 'Ketu', 'start': 0.0},
    {'name': 'Bharani', 'lord': 'Venus', 'start': 13.3333},
    {'name': 'Krittika', 'lord': 'Sun', 'start': 26.6667},
    {'name': 'Rohini', 'lord': 'Moon', 'start': 40.0},
    {'name': 'Mrigashira', 'lord': 'Mars', 'start': 53.3333},
    {'name': 'Ardra', 'lord': 'Rahu', 'start': 66.6667},
    {'name': 'Punarvasu', 'lord': 'Jupiter', 'start': 80.0},
    {'name': 'Pushya', 'lord': 'Saturn', 'start': 93.3333},
    {'name': 'Ashlesha', 'lord': 'Mercury', 'start': 106.6667},
    {'name': 'Magha', 'lord': 'Ketu', 'start': 120.0},
    {'name': 'Purva Phalguni', 'lord': 'Venus', 'start': 133.3333},
    {'name': 'Uttara Phalguni', 'lord': 'Sun', 'start': 146.6667},
    {'name': 'Hasta', 'lord': 'Moon', 'start': 160.0},
    {'name': 'Chitra', 'lord': 'Mars', 'start': 173.3333},
    {'name': 'Swati', 'lord': 'Rahu', 'start': 186.6667},
    {'name': 'Vishakha', 'lord': 'Jupiter', 'start': 200.0},
    {'name': 'Anuradha', 'lord': 'Saturn', 'start': 213.3333},
    {'name': 'Jyeshtha', 'lord': 'Mercury', 'start': 226.6667},
    {'name': 'Mula', 'lord': 'Ketu', 'start': 240.0},
    {'name': 'Purva Ashadha', 'lord': 'Venus', 'start': 253.3333},
    {'name': 'Uttara Ashadha', 'lord': 'Sun', 'start': 266.6667},
    {'name': 'Shravana', 'lord': 'Moon', 'start': 280.0},
    {'name': 'Dhanishta', 'lord': 'Mars', 'start': 293.3333},
    {'name': 'Shatabhisha', 'lord': 'Rahu', 'start': 306.6667},
    {'name': 'Purva Bhadrapada', 'lord': 'Jupiter', 'start': 320.0},
    {'name': 'Uttara Bhadrapada', 'lord': 'Saturn', 'start': 333.3333},
    {'name': 'Revati', 'lord': 'Mercury', 'start': 346.6667},
  ];
  
  // Planet Names
  static const List<String> planets = [
    'Sun',
    'Moon',
    'Mars',
    'Mercury',
    'Jupiter',
    'Venus',
    'Saturn',
    'Rahu',
    'Ketu',
  ];
  
  // Rashi Lords
  static const Map<int, String> rashiLord = {
    1: 'Mars',    // Mesha
    2: 'Venus',   // Vrishabha
    3: 'Mercury', // Mithuna
    4: 'Moon',    // Karka
    5: 'Sun',     // Simha
    6: 'Mercury', // Kanya
    7: 'Venus',   // Tula
    8: 'Mars',    // Vrishchika
    9: 'Jupiter', // Dhanu
    10: 'Saturn', // Makara
    11: 'Saturn', // Kumbha
    12: 'Jupiter', // Meena
  };
  
  // Gana for Nakshatras
  static const Map<int, String> nakshatraGana = {
    // Deva (divine)
    1: 'Deva', 4: 'Deva', 7: 'Deva', 12: 'Deva',
    16: 'Deva', 20: 'Deva', 21: 'Deva', 27: 'Deva',
    // Manushya (human)
    2: 'Manushya', 3: 'Manushya', 10: 'Manushya',
    11: 'Manushya', 13: 'Manushya', 15: 'Manushya',
    17: 'Manushya', 24: 'Manushya', 26: 'Manushya',
    // Rakshasa (demon)
    5: 'Rakshasa', 6: 'Rakshasa', 8: 'Rakshasa',
    9: 'Rakshasa', 14: 'Rakshasa', 18: 'Rakshasa',
    19: 'Rakshasa', 22: 'Rakshasa', 23: 'Rakshasa', 25: 'Rakshasa',
  };
  
  // Nadi for Nakshatras
  static const Map<int, String> nakshatraNadi = {
    // Aadi Nadi
    1: 'Aadi', 2: 'Aadi', 3: 'Aadi', 10: 'Aadi',
    11: 'Aadi', 12: 'Aadi', 19: 'Aadi', 20: 'Aadi', 21: 'Aadi',
    // Madhya Nadi
    4: 'Madhya', 5: 'Madhya', 6: 'Madhya', 13: 'Madhya',
    14: 'Madhya', 15: 'Madhya', 22: 'Madhya', 23: 'Madhya', 24: 'Madhya',
    // Antya Nadi
    7: 'Antya', 8: 'Antya', 9: 'Antya', 16: 'Antya',
    17: 'Antya', 18: 'Antya', 25: 'Antya', 26: 'Antya', 27: 'Antya',
  };
  
  // Yoni (Animal) for Nakshatras
  static const Map<int, String> nakshatraYoni = {
    1: 'Horse', 2: 'Elephant', 3: 'Sheep', 4: 'Snake',
    5: 'Dog', 6: 'Cat', 7: 'Rat', 8: 'Cat',
    9: 'Mongoose', 10: 'Rat', 11: 'Dog', 12: 'Snake',
    13: 'Buffalo', 14: 'Tiger', 15: 'Deer', 16: 'Deer',
    17: 'Monkey', 18: 'Monkey', 19: 'Dog', 20: 'Mongoose',
    21: 'Mongoose', 22: 'Monkey', 23: 'Lion', 24: 'Horse',
    25: 'Lion', 26: 'Cow', 27: 'Elephant'
  };
  
  // Yoni Enemies
  static const Map<String, List<String>> yoniEnemies = {
    'Horse': ['Buffalo'],
    'Elephant': ['Lion'],
    'Sheep': ['Monkey'],
    'Snake': ['Mongoose'],
    'Dog': ['Deer'],
    'Cat': ['Rat'],
    'Cow': ['Tiger'],
    'Tiger': ['Cow'],
    'Rat': ['Cat'],
    'Mongoose': ['Snake'],
    'Deer': ['Dog'],
    'Lion': ['Elephant'],
    'Buffalo': ['Horse'],
    'Monkey': ['Sheep'],
  };
  
  // Planetary Friendships
  static const Map<String, List<String>> planetaryFriends = {
    'Sun': ['Moon', 'Mars', 'Jupiter'],
    'Moon': ['Sun', 'Mercury'],
    'Mars': ['Sun', 'Moon', 'Jupiter'],
    'Mercury': ['Sun', 'Venus'],
    'Jupiter': ['Sun', 'Moon', 'Mars'],
    'Venus': ['Mercury', 'Saturn'],
    'Saturn': ['Mercury', 'Venus'],
  };
  
  // Varna for Rashis
  static const Map<int, int> rashiVarna = {
    1: 1, 5: 1, 9: 1,    // Brahmin (Mesha, Simha, Dhanu)
    2: 2, 6: 2, 10: 2,   // Kshatriya (Vrishabha, Kanya, Makara)
    3: 3, 7: 3, 11: 3,   // Vaishya (Mithuna, Tula, Kumbha)
    4: 4, 8: 4, 12: 4,   // Shudra (Karka, Vrishchika, Meena)
  };
  
  // Vashya Map
  static const Map<int, List<int>> vashyaMap = {
    1: [1, 5, 7, 8],     // Mesha
    2: [2, 6, 7],        // Vrishabha
    3: [3, 6],           // Mithuna
    4: [4, 8],           // Karka
    5: [1, 5],           // Simha
    6: [2, 3, 6],        // Kanya
    7: [2, 7, 11],       // Tula
    8: [4, 8],           // Vrishchika
    9: [9, 12],          // Dhanu
    10: [10, 11],        // Makara
    11: [7, 10, 11],     // Kumbha
    12: [9, 12],         // Meena
  };
}
