import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/chat_storage_service.dart';
import '../services/gemini_api_service.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final chatStorageProvider = Provider<ChatStorageService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ChatStorageService(prefs);
});

final geminiApiProvider = Provider<GeminiApiService>((ref) {
  return GeminiApiService();
});
