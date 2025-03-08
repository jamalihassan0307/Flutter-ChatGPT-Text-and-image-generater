import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const primaryColor = Color(0xFF10A37F);
  static const darkBackground = Color(0xFF343541);
  static const darkSurface = Color(0xFF444654);
  static const darkDivider = Color(0xFF4D4D4D);
  static const textColor = Color(0xFFD1D5DB);

  // Light Theme
  static final lightTheme = ThemeData.light().copyWith(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.grey[100],
    dividerColor: Colors.grey[300],
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black87),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      foregroundColor: Colors.white,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        return states.contains(MaterialState.selected) 
          ? primaryColor 
          : Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        return states.contains(MaterialState.selected) 
          ? primaryColor.withOpacity(0.5) 
          : Colors.grey.withOpacity(0.5);
      }),
    ),
  );

  // Dark Theme
  static final darkTheme = ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: darkBackground,
    cardColor: darkSurface,
    dividerColor: darkDivider,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textColor),
      bodyMedium: TextStyle(color: textColor),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      elevation: 0,
      foregroundColor: textColor,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryColor,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        return states.contains(MaterialState.selected) 
          ? primaryColor 
          : Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        return states.contains(MaterialState.selected) 
          ? primaryColor.withOpacity(0.5) 
          : Colors.grey.withOpacity(0.5);
      }),
    ),
    iconTheme: const IconThemeData(
      color: textColor,
    ),
  );
} 