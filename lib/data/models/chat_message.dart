class ChatMessage {
  final String query;
  final String response;
  final DateTime timestamp;

  ChatMessage({
    required this.query,
    required this.response,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'query': query,
        'response': response,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        query: json['query'],
        response: json['response'],
        timestamp: DateTime.parse(json['timestamp']),
      );
} 