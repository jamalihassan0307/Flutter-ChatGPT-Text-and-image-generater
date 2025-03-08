import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chat.dart';

class ChatStorageService {
  static const String _key = 'chats';
  final SharedPreferences _prefs;

  ChatStorageService(this._prefs);

  Future<List<Chat>> getChats() async {
    final jsonList = _prefs.getStringList(_key) ?? [];
    return jsonList
        .map((str) => Chat.fromJson(jsonDecode(str)))
        .toList();
  }

  Future<void> saveChats(List<Chat> chats) async {
    final jsonList = chats.map((c) => jsonEncode(c.toJson())).toList();
    await _prefs.setStringList(_key, jsonList);
  }
} 