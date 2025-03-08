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
                text: text,
                cursor: const TypewriterCursor(color: Colors.green),
                textStyle: const TextStyle(
                  color: Color(0xFFD1D5DB),
                  fontSize: 16,
                ),
                markdownConfig: MarkdownConfig(
                  boldConfig: BoldConfig(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  italicConfig: ItalicConfig(
                    textStyle: const TextStyle(
                      color: Color(0xFFD1D5DB),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  codeConfig: CodeConfig(
                    textStyle: const TextStyle(
                      color: Color(0xFF85E89D),
                      fontFamily: 'monospace',
                    ),
                    backgroundColor: const Color(0xFF2D333B),
                    borderRadius: BorderRadius.circular(4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 2,
                    ),
                  ),
                  bulletConfig: BulletConfig(
                    bullet: '•',
                    bulletColor: const Color(0xFF85E89D),
                    indentation: 20,
                  ),
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
