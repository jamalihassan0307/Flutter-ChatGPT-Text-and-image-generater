import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt_text_and_image_processing/configs/utils.dart';
import 'package:rich_typewriter/rich_typewriter.dart';
import '../../../models/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback onShare;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildMessageBubble(
          context,
          message.query,
          isUser: true,
        ),
        const SizedBox(height: 8),
        _buildMessageBubble(
          context,
          message.response,
          isUser: false,
        ),
      ],
    );
  }

  List<TextSpan> _processText(String text) {
    final List<TextSpan> spans = [];
    final paragraphs = text.split('\n\n');

    for (final paragraph in paragraphs) {
      if (paragraph.startsWith('**') && paragraph.endsWith('**')) {
        // Headers
        spans.add(TextSpan(
          text: '${paragraph.replaceAll('**', '')}\n',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
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
            else
              RichTypewriter(
                symbolDelay: (symbol) =>
                    switch (symbol) { TextSpan(text: ' ') => 50, TextSpan(text: '\n') => 200, _ => 20 },
                onCompleted: () => debugPrint('Finished typing response'),
                child: SelectableText.rich(
                  TextSpan(children: _processText(text)),
                ),
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
                    onPressed: onShare,
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
