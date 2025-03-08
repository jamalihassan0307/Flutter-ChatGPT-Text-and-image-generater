import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_text_and_image_processing/configs/theme/app_theme.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences.dart';
import '../models/theme_settings.dart';

final themeSettingsProvider = StateNotifierProvider<ThemeSettingsNotifier, ThemeSettings>((ref) {
  return ThemeSettingsNotifier();
});

class ThemeSettingsNotifier extends StateNotifier<ThemeSettings> {
  static const String _storageKey = 'themeSettings';

  ThemeSettingsNotifier() : super(_defaultSettings) {
    _initializeSettings();
  }

  static const _defaultSettings = ThemeSettings(
    backgroundImage: 'assets/themeImages/aiBackground.jpeg',
    primaryColor: AppTheme.primaryColor,
    secondaryColor: Colors.teal,
    systemBubbleColor: Color(0xFF444654),
    userBubbleColor: Color(0xFF343541),
    textColor: Colors.white,
    textColorSecondary: Colors.white70,
  );

  Future<void> _initializeSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString(_storageKey);

      if (settingsJson != null) {
        final settings = ThemeSettings.fromJson(json.decode(settingsJson));
        state = settings;
      } else {
        // Save default settings if none exist
        await updateSettings(_defaultSettings);
      }
    } catch (e) {
      // Fallback to default settings on error
      state = _defaultSettings;
    }
  }

  Future<void> updateSettings(ThemeSettings settings) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_storageKey, json.encode(settings.toJson()));
      state = settings;
    } catch (e) {
      // Handle error (could show an error message)
      print('Error saving theme settings: $e');
    }
  }

  // Helper method to update individual properties
  Future<void> updateThemeColors({
    Color? primaryColor,
    Color? secondaryColor,
    Color? systemBubbleColor,
    Color? userBubbleColor,
    Color? textColor,
    Color? textColorSecondary,
  }) async {
    final newSettings = state.copyWith(
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      systemBubbleColor: systemBubbleColor,
      userBubbleColor: userBubbleColor,
      textColor: textColor,
      textColorSecondary: textColorSecondary,
    );
    await updateSettings(newSettings);
  }

  Future<void> updateBackgroundImage(String imagePath) async {
    final newSettings = state.copyWith(backgroundImage: imagePath);
    await updateSettings(newSettings);
  }
}
