import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/chat_conversation.dart';
import '../models/chat_message.dart';

class DatabaseService {
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'chat.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE conversations(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            created_at TEXT NOT NULL,
            updated_at TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE messages(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            conversation_id INTEGER NOT NULL,
            query TEXT NOT NULL,
            response TEXT NOT NULL,
            timestamp TEXT NOT NULL,
            FOREIGN KEY (conversation_id) REFERENCES conversations (id)
              ON DELETE CASCADE
          )
        ''');
      },
    );
  }

  // Conversation methods
  Future<ChatConversation> createConversation(String title) async {
    final db = await database;
    final now = DateTime.now();
    
    final conversation = ChatConversation(
      title: title,
      createdAt: now,
      updatedAt: now,
    );

    final id = await db.insert('conversations', conversation.toMap());
    return conversation.copyWith(id: id);
  }

  Future<List<ChatConversation>> getConversations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'conversations',
      orderBy: 'updated_at DESC',
    );

    return List.generate(maps.length, (i) => ChatConversation.fromMap(maps[i]));
  }

  Future<void> updateConversationTitle(int id, String newTitle) async {
    final db = await database;
    await db.update(
      'conversations',
      {
        'title': newTitle,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteConversation(int id) async {
    final db = await database;
    await db.delete(
      'conversations',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Message methods
  Future<void> saveMessage(ChatMessage message) async {
    final db = await database;
    await db.insert('messages', message.toMap());
    
    // Update conversation's updated_at timestamp
    await db.update(
      'conversations',
      {'updated_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [message.conversationId],
    );
  }

  Future<List<ChatMessage>> getMessages(int conversationId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'messages',
      where: 'conversation_id = ?',
      whereArgs: [conversationId],
      orderBy: 'timestamp ASC',
    );

    return List.generate(maps.length, (i) => ChatMessage.fromMap(maps[i]));
  }
} 