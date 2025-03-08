import 'package:uuid/uuid.dart';
import 'chat_message.dart';

class Chat {
  final String id;
  final String name;
  final List<ChatMessage> messages;
  final DateTime createdAt;

  Chat({
    String? id,
    required this.name,
    List<ChatMessage>? messages,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        messages = messages ?? [],
        createdAt = createdAt ?? DateTime.now();

  Chat copyWith({
    String? name,
    List<ChatMessage>? messages,
  }) {
    return Chat(
      id: id,
      name: name ?? this.name,
      messages: messages ?? this.messages,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'messages': messages.map((m) => m.toJson()).toList(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        id: json['id'],
        name: json['name'],
        messages: (json['messages'] as List).map((m) => ChatMessage.fromJson(m)).toList(),
        createdAt: DateTime.parse(json['createdAt']),
      );
}
