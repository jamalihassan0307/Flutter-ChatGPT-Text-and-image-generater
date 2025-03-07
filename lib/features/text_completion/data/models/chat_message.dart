class ChatMessage {
  final int? id;
  final int conversationId;
  final String query;
  final String response;
  final DateTime timestamp;

  ChatMessage({
    this.id,
    required this.conversationId,
    required this.query,
    required this.response,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'conversation_id': conversationId,
      'query': query,
      'response': response,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      conversationId: map['conversation_id'],
      query: map['query'],
      response: map['response'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
} 