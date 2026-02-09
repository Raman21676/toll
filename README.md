# AstroConnect - Vedic Astrology Social App

A comprehensive Flutter application combining Vedic astrology features with social networking capabilities. Users can generate their Janma Kundali (birth chart), perform Gun Milan (compatibility matching), and connect with like-minded individuals.

## 🌟 Features

### Phase 0 & 1: Complete ✅
- **Project Setup**: Flutter project with Firebase integration
- **Authentication**: Email/password signup/login with verification
- **User Profiles**: Complete profile management with interests and hobbies
- **Theming**: Beautiful cosmic theme with light/dark mode support

### Phase 2: Astrology Module ✅
- **Janma Kundali**: Generate accurate birth charts
- **Planetary Positions**: Calculate positions for all 9 planets
- **Rashi & Nakshatra**: Determine moon sign and birth star
- **House Calculations**: 12 house (bhava) calculations

### Phase 3: Chinaa Matching ✅
- **Gun Milan (Ashtakoot)**: 8-point compatibility system
  - Varna (1 point) - Spiritual development
  - Vashya (2 points) - Mutual attraction
  - Tara (3 points) - Birth star compatibility
  - Yoni (4 points) - Animal compatibility
  - Graha Maitri (5 points) - Planetary friendship
  - Gana (6 points) - Temperament matching
  - Bhakoot (7 points) - Sign position compatibility
  - Nadi (8 points) - Health & progeny
- **Dosha Detection**: Manglik, Nadi Dosha, Bhakoot Dosha
- **Compatibility Report**: Detailed analysis with percentage

### Phase 4: Social Features (In Progress)
- User profiles with kundali integration
- Friend system
- Posts and feeds
- Chat functionality
- Video reels

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Firebase account
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone git@github.com:Raman21676/toll.git
   cd toll/astro_social_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a new Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
   - Add Android app with package name: `com.ramansubedi.astro_social_app`
   - Download `google-services.json` and place in `android/app/`
   - Add iOS app if needed
   - Enable Authentication (Email/Password method)
   - Create Firestore database (start in test mode)
   - Set up Firebase Storage

4. **Update Firebase configuration**
   Replace the placeholder values in `lib/main.dart` with your actual Firebase configuration:
   ```dart
   await Firebase.initializeApp(
     options: const FirebaseOptions(
       apiKey: "YOUR_ACTUAL_API_KEY",
       authDomain: "YOUR_PROJECT.firebaseapp.com",
       projectId: "YOUR_PROJECT_ID",
       storageBucket: "YOUR_PROJECT.appspot.com",
       messagingSenderId: "YOUR_SENDER_ID",
       appId: "YOUR_APP_ID",
     ),
   );
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/       # App constants, astrology data
│   ├── routes/          # Navigation routes
│   ├── themes/          # App theming
│   └── utils/           # Utility functions
├── models/
│   ├── user_model.dart
│   ├── birth_details_model.dart
│   ├── janma_kundali_model.dart
│   ├── planet_position_model.dart
│   └── chinaa_model.dart
├── services/
│   ├── auth_service.dart
│   ├── user_service.dart
│   └── astrology_service.dart
├── providers/
│   └── auth_provider.dart
├── screens/
│   ├── auth/
│   │   ├── splash_screen.dart
│   │   ├── welcome_screen.dart
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   └── email_verification_screen.dart
│   ├── astrology/
│   │   ├── birth_details_screen.dart
│   │   ├── kundali_display_screen.dart
│   │   └── chinaa_matching_screen.dart
│   ├── home/
│   │   └── home_feed_screen.dart
│   ├── profile/
│   │   ├── user_profile_screen.dart
│   │   └── edit_profile_screen.dart
│   └── reels/
│       └── reels_feed_screen.dart
├── widgets/
│   ├── custom_text_field.dart
│   ├── custom_button.dart
│   └── create_post_bottom_sheet.dart
└── main.dart
```

## 🔮 Astrology Calculations

The app implements Vedic astrology calculations without requiring external APIs:

### Key Algorithms
- **Julian Day Number**: For astronomical date calculations
- **Lahiri Ayanamsa**: For tropical to sidereal conversion
- **Planetary Positions**: Simplified algorithms for all planets
- **Rashi & Nakshatra**: Based on moon longitude
- **Lagna (Ascendant)**: Using local sidereal time
- **Gun Milan**: Complete Ashtakoot system

### Accuracy
The calculations provide good accuracy for general purposes. For production-grade precision, consider integrating:
- Swiss Ephemeris library
- Backend API with professional astrology software

## 🛠️ Technologies Used

- **Flutter**: UI framework
- **Firebase**: Backend services
  - Firebase Auth: Authentication
  - Cloud Firestore: Database
  - Firebase Storage: File storage
- **Provider**: State management
- **Various Flutter packages**: UI components, image picking, etc.

## 📋 Development Roadmap

### Phase 0-1: ✅ Complete
- [x] Project setup
- [x] Firebase configuration
- [x] Authentication system
- [x] User registration with interests/hobbies
- [x] Profile management

### Phase 2: ✅ Complete
- [x] Birth details input
- [x] Janma Kundali generation
- [x] Planetary position calculations
- [x] Rashi & Nakshatra determination
- [x] House (Bhava) calculations
- [x] Kundali display UI

### Phase 3: ✅ Complete
- [x] Gun Milan (Ashtakoot) algorithm
- [x] All 8 koota calculations
- [x] Dosha detection (Manglik, Nadi, Bhakoot)
- [x] Compatibility percentage
- [x] Detailed match report

### Phase 4: In Progress
- [x] User profile enhancements
- [ ] User search system
- [ ] Compatibility display in search results
- [ ] Friend request system

### Phase 5+: Planned
- [ ] Posts and social feed
- [ ] Chat system
- [ ] Video reels
- [ ] Notifications
- [ ] Settings and preferences

## 🤝 Contributing

This project is being developed with the help of AI coding assistance. Feel free to fork and contribute!

## 📝 License

This project is for educational and personal use.

## 🙏 Acknowledgments

- Vedic astrology formulas from traditional texts
- Flutter and Firebase teams for excellent documentation
- Open source community for various packages used

---

**Built with 💙 and cosmic energy** ✨
