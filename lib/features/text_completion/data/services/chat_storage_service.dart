import '../models/chat_message.dart';
import 'database_service.dart';

class ChatStorageService {
  final DatabaseService _db;

  ChatStorageService(this._db);

  Future<void> saveMessage(ChatMessage message) async {
    await _db.saveMessage(message);
  }

  Future<List<ChatMessage>> getMessages(int conversationId) async {
    return await _db.getMessages(conversationId);
  }
}
