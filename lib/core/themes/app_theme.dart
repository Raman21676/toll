import 'package:flutter/material.dart';

class AppTheme {
  // Primary Colors - Light Blue to Light Purple Gradient Palette
  static const Color lightBlue = Color(0xFFE3F2FD);    // Light Blue 50
  static const Color lightBlue100 = Color(0xFFBBDEFB); // Light Blue 100
  static const Color lightBlue200 = Color(0xFF90CAF9); // Light Blue 200
  static const Color lightBlue300 = Color(0xFF64B5F6); // Light Blue 300
  static const Color lightBlue400 = Color(0xFF42A5F5); // Light Blue 400
  static const Color lightBlue500 = Color(0xFF2196F3); // Light Blue 500
  
  static const Color lightPurple = Color(0xFFF3E5F5);    // Purple 50
  static const Color lightPurple100 = Color(0xFFE1BEE7); // Purple 100
  static const Color lightPurple200 = Color(0xFFCE93D8); // Purple 200
  static const Color lightPurple300 = Color(0xFFBA68C8); // Purple 300
  static const Color lightPurple400 = Color(0xFFAB47BC); // Purple 400
  static const Color lightPurple500 = Color(0xFF9C27B0); // Purple 500

  // Gradient Definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [lightBlue200, lightPurple200],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient primaryGradientVertical = LinearGradient(
    colors: [lightBlue100, lightPurple100],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient buttonGradient = LinearGradient(
    colors: [lightBlue400, lightPurple400],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  
  static const LinearGradient cardGradient = LinearGradient(
    colors: [Colors.white, lightBlue],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
  
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [lightPurple, lightBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 1.0],
  );
  
  static const LinearGradient cosmicGradient = LinearGradient(
    colors: [Color(0xFF1A237E), Color(0xFF4A148C), Color(0xFF311B92)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Accent Colors
  static const Color accentGold = Color(0xFFFFD700);
  static const Color accentOrange = Color(0xFFFFA726);
  static const Color accentPink = Color(0xFFF48FB1);
  
  // Legacy aliases for backward compatibility
  static const Color primaryColor = lightBlue500;
  static const Color primaryLight = lightBlue200;
  static const Color secondaryColor = lightPurple500;
  static const Color secondaryLight = lightPurple300;
  
  // Gradients
  static const LinearGradient goldGradient = LinearGradient(
    colors: [accentGold, accentOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  // Status Colors
  static const Color success = Color(0xFF66BB6A);
  static const Color error = Color(0xFFEF5350);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF42A5F5);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color surfaceLight = Colors.white;
  
  // Text Colors
  static const Color textPrimaryLight = Color(0xFF1A237E);
  static const Color textSecondaryLight = Color(0xFF5C6BC0);
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Color(0xFFB39DDB);

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundLight,
    colorScheme: const ColorScheme.light(
      primary: lightBlue500,
      secondary: lightPurple500,
      surface: surfaceLight,
      background: backgroundLight,
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimaryLight,
      onBackground: textPrimaryLight,
      onError: Colors.white,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: lightBlue.withValues(alpha: 0.7),
      foregroundColor: textPrimaryLight,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      color: surfaceLight,
      shadowColor: lightPurple200.withValues(alpha: 0.3),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightBlue.withValues(alpha: 0.3),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: lightBlue200.withValues(alpha: 0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: lightPurple300, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: error, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      hintStyle: TextStyle(color: textSecondaryLight.withValues(alpha: 0.6)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: lightBlue500,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: lightPurple500,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        side: const BorderSide(color: lightBlue400, width: 2),
        foregroundColor: lightBlue500,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: lightPurple500,
      unselectedItemColor: textSecondaryLight.withValues(alpha: 0.5),
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: lightBlue.withValues(alpha: 0.5),
      selectedColor: lightPurple200,
      labelStyle: const TextStyle(color: textPrimaryLight),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      side: BorderSide.none,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: lightPurple400,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: lightBlue200.withValues(alpha: 0.5),
      thickness: 1,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryLight,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimaryLight,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryLight,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textPrimaryLight,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textSecondaryLight,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: lightBlue500,
      ),
    ),
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1A1A2E),
    colorScheme: const ColorScheme.dark(
      primary: lightBlue300,
      secondary: lightPurple300,
      surface: Color(0xFF16213E),
      background: Color(0xFF1A1A2E),
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textPrimaryDark,
      onBackground: textPrimaryDark,
      onError: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Color(0xFF16213E),
      foregroundColor: textPrimaryDark,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      color: const Color(0xFF16213E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF0F3460),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: lightPurple300, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: error, width: 1),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: lightPurple400,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: lightPurple300,
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF16213E),
      selectedItemColor: lightPurple300,
      unselectedItemColor: textSecondaryDark,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFF0F3460),
      selectedColor: lightPurple400,
      labelStyle: const TextStyle(color: textPrimaryDark),
      secondaryLabelStyle: const TextStyle(color: Colors.white),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: textPrimaryDark,
      ),
      displaySmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimaryDark,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textPrimaryDark,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textSecondaryDark,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: lightPurple300,
      ),
    ),
  );
}
