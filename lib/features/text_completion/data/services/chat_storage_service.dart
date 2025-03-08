import 'dart:convert';
import 'package:shared_preferences.dart';
import '../models/chat_message.dart';

class ChatStorageService {
  static const String _key = 'chat_history';
  final SharedPreferences _prefs;

  ChatStorageService(this._prefs);

  Future<void> saveMessage(ChatMessage message) async {
    final messages = await getMessages();
    messages.add(message);
    final jsonList = messages.map((m) => jsonEncode(m.toJson())).toList();
    await _prefs.setStringList(_key, jsonList);
  }

  Future<List<ChatMessage>> getMessages() async {
    final jsonList = _prefs.getStringList(_key) ?? [];
    return jsonList
        .map((str) => ChatMessage.fromJson(jsonDecode(str)))
        .toList();
  }

  Future<void> clearMessages() async {
    await _prefs.remove(_key);
  }
} 