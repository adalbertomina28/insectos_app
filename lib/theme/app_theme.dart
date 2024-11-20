import 'package:flutter/material.dart';

class AppTheme {
  // Paleta de colores principal
  static const Color calPolyGreen = Color(0xFF2A4D14);
  static const Color officeGreen = Color(0xFF317B22);
  static const Color emerald = Color(0xFF67E0A3);
  static const Color aquamarine = Color(0xFF7CF0BD);
  static const Color celadon = Color(0xFFAFF9C9);

  // Colores de la aplicación
  static const Color primaryColor = officeGreen;
  static const Color backgroundColor = calPolyGreen;
  static const Color cardColor = Color(0xFF2A4D14);
  
  // Colores de texto
  static const Color textPrimaryColor = Colors.white;
  static const Color textSecondaryColor = celadon;
  static const Color textLightColor = aquamarine;

  // Gradientes
  static final LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      calPolyGreen,
      officeGreen,
      emerald.withOpacity(0.8),
    ],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [emerald, aquamarine, celadon],
  );

  // Radios
  static const double cardRadius = 16.0;
  static const double buttonRadius = 12.0;
  static const double chipRadius = 8.0;

  // Espaciado
  static const double spacing = 16.0;
  static const double spacingSmall = 8.0;
  static const double spacingLarge = 24.0;

  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: ColorScheme.dark(
          primary: primaryColor,
          secondary: emerald,
          surface: cardColor,
          background: backgroundColor,
          error: Colors.red.shade700,
          onPrimary: Colors.white,
          onSecondary: calPolyGreen,
          onSurface: Colors.white,
          onBackground: Colors.white,
          onError: Colors.white,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundColor,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        cardTheme: CardTheme(
          color: cardColor,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(cardRadius),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            color: textPrimaryColor,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: textPrimaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: TextStyle(
            color: textPrimaryColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: TextStyle(
            color: textPrimaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          bodyLarge: TextStyle(
            color: textSecondaryColor,
            fontSize: 16,
          ),
          bodyMedium: TextStyle(
            color: textSecondaryColor,
            fontSize: 14,
          ),
        ),
        iconTheme: const IconThemeData(
          color: textPrimaryColor,
        ),
        chipTheme: ChipThemeData(
          backgroundColor: emerald.withOpacity(0.2),
          labelStyle: const TextStyle(color: textPrimaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: emerald,
            foregroundColor: calPolyGreen,
            padding: const EdgeInsets.symmetric(
              horizontal: spacing * 2,
              vertical: spacing,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: emerald,
            padding: const EdgeInsets.symmetric(
              horizontal: spacing * 2,
              vertical: spacing,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(buttonRadius),
            ),
            side: const BorderSide(color: emerald),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(buttonRadius),
            borderSide: const BorderSide(color: emerald),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: spacing,
            vertical: spacing,
          ),
          hintStyle: const TextStyle(color: textLightColor, fontSize: 14),
        ),
      );
}
