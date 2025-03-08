import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt_text_and_image_processing/configs/utils.dart';
import 'package:typewritertext/typewritertext.dart';
import '../../../models/chat_message.dart';

class ChatMessageBubble extends StatefulWidget {
  final ChatMessage message;
  final VoidCallback onShare;
  final bool isNewMessage;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.onShare,
    this.isNewMessage = false,
  });

  @override
  State<ChatMessageBubble> createState() => _ChatMessageBubbleState();
}

class _ChatMessageBubbleState extends State<ChatMessageBubble> {
  bool _showFullText = false;

  @override
  void initState() {
    super.initState();
    if (!widget.isNewMessage) {
      _showFullText = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMessageBubble(
          context,
          widget.message.query,
          isUser: true,
        ),
        const SizedBox(height: 8),
        _buildMessageBubble(
          context,
          widget.message.response,
          isUser: false,
        ),
      ],
    );
  }

  List<TextSpan> _processText(String text) {
    final List<TextSpan> spans = [];
    final paragraphs = text.split('\n\n');

    for (final paragraph in paragraphs) {
      if (paragraph.startsWith('# ')) {
        // H1 Headers
        spans.add(TextSpan(
          text: '${paragraph.substring(2)}\n',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ));
      } else if (paragraph.startsWith('## ')) {
        // H2 Headers
        spans.add(TextSpan(
          text: '${paragraph.substring(3)}\n',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ));
      } else if (paragraph.startsWith('* ')) {
        // Bullet points
        spans.add(TextSpan(
          text: '• ${paragraph.substring(2)}\n',
          style: const TextStyle(
            color: Color(0xFFD1D5DB),
          ),
        ));
      } else if (paragraph.startsWith('```')) {
        // Code blocks
        final code = paragraph.replaceAll('```', '').trim();
        spans.add(TextSpan(
          text: '$code\n',
          style: const TextStyle(
            color: Color(0xFF85E89D),
            fontFamily: 'monospace',
            backgroundColor: Color(0xFF2D333B),
          ),
        ));
      } else {
        // Regular text
        spans.add(TextSpan(
          text: '$paragraph\n',
          style: const TextStyle(
            color: Color(0xFFD1D5DB),
          ),
        ));
      }
    }

    return spans;
  }

  Widget _buildMessageBubble(BuildContext context, String text, {required bool isUser}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Theme.of(context).primaryColor : const Color(0xFF444654),
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isUser)
              SelectableText(
                text,
                style: const TextStyle(color: Colors.white),
              )
            else if (_showFullText)
              SelectableText(
                text,
                style: const TextStyle(
                  color: Color(0xFFD1D5DB),
                  fontSize: 16,
                ),
              )
            else
              TypeWriterText(
                maintainSize: true,
                repeat: false,
                text: Text(
                  text,
                  style: const TextStyle(
                    color: Color(0xFFD1D5DB),
                    fontSize: 16,
                  ),
                ),
                duration: const Duration(milliseconds: 30),
                onEnd: () {
                  setState(() {
                    _showFullText = true;
                  });
                },
              ),
            if (!isUser) ...[
              const Divider(color: Color(0xFF4D4D4D)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.copy,
                      size: 20,
                      color: Color(0xFFD1D5DB),
                    ),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: text));
                      Utils.flushBarSuccessMessage('Copied to clipboard', context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.share,
                      size: 20,
                      color: Color(0xFFD1D5DB),
                    ),
                    onPressed: widget.onShare,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
