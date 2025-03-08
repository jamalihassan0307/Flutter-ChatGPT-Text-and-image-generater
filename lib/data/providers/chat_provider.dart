import 'package:flutter_chatgpt_text_and_image_processing/data/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/chat.dart';
import '../models/chat_message.dart';
import '../services/chat_storage_service.dart';
import '../services/gemini_api_service.dart';
import 'package:uuid/uuid.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, List<Chat>>((ref) {
  final storage = ref.watch(chatStorageProvider);
  final api = ref.watch(geminiApiProvider);
  return ChatNotifier(storage, api);
});

class ChatNotifier extends StateNotifier<List<Chat>> {
  final ChatStorageService _storage;
  final GeminiApiService _api;

  ChatNotifier(this._storage, this._api) : super([]) {
    _loadChats();
  }

  Future<void> _loadChats() async {
    state = await _storage.getChats();
  }

  Future<void> createChat(String name) async {
    final chat = Chat(name: name);
    state = [...state, chat];
    await _storage.saveChats(state);
  }

  Future<void> deleteChat(String chatId) async {
    state = state.where((chat) => chat.id != chatId).toList();
    await _storage.saveChats(state);
  }

  Future<void> renameChat(String chatId, String newName) async {
    state = state.map((chat) {
      if (chat.id == chatId) {
        return chat.copyWith(name: newName);
      }
      return chat;
    }).toList();
    await _storage.saveChats(state);
  }

  Future<void> sendMessage(String chatId, String message) async {
    try {
      final response = await _api.generateContent(message);
      final aiResponse = response['candidates'][0]['content']['parts'][0]['text'];

      final newMessage = ChatMessage(
        id: const Uuid().v4(),
        query: message,
        response: aiResponse,
        timestamp: DateTime.now(),
      );

      state = state.map((chat) {
        if (chat.id == chatId) {
          return chat.copyWith(
            messages: [
              ...chat.messages,
              newMessage,
            ],
          );
        }
        return chat;
      }).toList();

      await _storage.saveChats(state);
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Future<void> deleteMessage(String chatId, String messageId) async {
    state = state.map((chat) {
      if (chat.id == chatId) {
        return chat.copyWith(
          messages: chat.messages.where((m) => m.id != messageId).toList(),
        );
      }
      return chat;
    }).toList();

    // Save updated chats to storage
    await _storage.saveChats(state);
  }
}
