class ChatMessage {
  final String role;
  final String content;
  final int timestamp;
  final String? imageUrl;

  ChatMessage({
    required this.role,
    required this.content,
    required this.timestamp,
    this.imageUrl,
  });
} 