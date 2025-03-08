class ChatMessage {
  final String id;
  final String query;
  final String response;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.query,
    required this.response,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'query': query,
    'response': response,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'],
    query: json['query'],
    response: json['response'],
    timestamp: DateTime.parse(json['timestamp']),
  );
} 