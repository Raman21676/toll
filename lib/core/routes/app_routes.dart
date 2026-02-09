import 'package:flutter/material.dart';
import '../../screens/auth/splash_screen.dart';
import '../../screens/auth/welcome_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/email_verification_screen.dart';
import '../../screens/main_screen.dart';
import '../../screens/astrology/birth_details_screen.dart';
import '../../screens/astrology/kundali_display_screen.dart';
import '../../screens/astrology/chinaa_matching_screen.dart';
import '../../screens/profile/user_profile_screen.dart';
import '../../screens/profile/edit_profile_screen.dart';

class AppRoutes {
  // Route names
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String emailVerification = '/email-verification';
  static const String main = '/main';
  static const String birthDetails = '/birth-details';
  static const String kundali = '/kundali';
  static const String chinaaMatch = '/chinaa-match';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  
  // Route map
  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    welcome: (context) => const WelcomeScreen(),
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    emailVerification: (context) => const EmailVerificationScreen(),
    main: (context) => const MainScreen(),
    birthDetails: (context) => const BirthDetailsScreen(),
    kundali: (context) => const KundaliDisplayScreen(),
    chinaaMatch: (context) => const ChinaaMatchingScreen(),
    profile: (context) => const UserProfileScreen(),
    editProfile: (context) => const EditProfileScreen(),
  };
  
  // Generate routes with arguments
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case profile:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => UserProfileScreen(
            userId: args?['userId'],
          ),
        );
      case kundali:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => KundaliDisplayScreen(
            kundali: args?['kundali'],
          ),
        );
      case chinaaMatch:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => ChinaaMatchingScreen(
            userId: args?['userId'],
          ),
        );
      default:
        return null;
    }
  }
  
  // Navigate with slide transition
  static Route slideTransition(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        
        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
