import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/saved_user.dart';

class SharedPrefsService {
  static const String _savedUsersKey = 'saved_users';

  static Future<List<SavedUser>> getSavedUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsersJson = prefs.getStringList(_savedUsersKey) ?? [];
    return savedUsersJson.map((json) => SavedUser.fromJson(jsonDecode(json))).toList();
  }

  static Future<void> saveUser(SavedUser user) async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsers = await getSavedUsers();

    // Remove if already exists
    savedUsers.removeWhere((u) => u.email == user.email);

    // Add new user
    savedUsers.add(user);

    // Save updated list
    await prefs.setStringList(
      _savedUsersKey,
      savedUsers.map((u) => jsonEncode(u.toJson())).toList(),
    );
  }

  static Future<void> removeSavedUser(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsers = await getSavedUsers();
    savedUsers.removeWhere((u) => u.email == email);
    await prefs.setStringList(
      _savedUsersKey,
      savedUsers.map((u) => jsonEncode(u.toJson())).toList(),
    );
  }

  static Future<SavedUser?> getSavedUser(String email) async {
    final savedUsers = await getSavedUsers();
    return savedUsers.firstWhere(
      (user) => user.email == email,
      orElse: () => SavedUser(email: '', password: '', name: '', savedAt: DateTime.now()),
    );
  }
}
