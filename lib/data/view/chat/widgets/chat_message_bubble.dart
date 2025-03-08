import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/chat_message.dart';
import '../../../configs/utils.dart';

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

  Widget _buildMessageBubble(BuildContext context, String text, {required bool isUser}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(text),
            if (!isUser) ...[
              const Divider(),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy, size: 20),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: text));
                      Utils.flushBarSuccessMessage('Copied to clipboard', context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.share, size: 20),
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
