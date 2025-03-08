import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt_text_and_image_processing/configs/utils.dart';
import 'package:typewritertext/typewritertext.dart';
import '../../../models/chat_message.dart';

class ChatMessageBubble extends StatefulWidget {
  final ChatMessage message;
  final VoidCallback onShare;
  final VoidCallback? onDelete;
  final bool isNewMessage;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.onShare,
    this.onDelete,
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
      if (paragraph.startsWith('#')) {
        // H1 Headers
        spans.add(TextSpan(
          text: paragraph.substring(2),
          style: const TextStyle(
            color: Color(0xFF10A37F), // ChatGPT green for headers
            fontSize: 24,
            fontWeight: FontWeight.bold,
            height: 2.0,
          ),
        ));
      } else if (paragraph.startsWith('##')) {
        // H2 Headers
        spans.add(TextSpan(
          text: paragraph.substring(3),
          style: const TextStyle(
            color: Color(0xFF10A37F),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            height: 1.8,
          ),
        ));
      } else if (paragraph.startsWith('###')) {
        // H3 Headers
        spans.add(TextSpan(
          text: paragraph.substring(4),
          style: const TextStyle(
            color: Color(0xFF10A37F),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            height: 1.6,
          ),
        ));
      } else if (paragraph.startsWith('*') || paragraph.startsWith('-')) {
        // Bullet points
        spans.add(TextSpan(
          text: '• ${paragraph.substring(1)}',
          style: const TextStyle(
            color: Color(0xFFD1D5DB),
            height: 1.5,
            fontSize: 16,
          ),
        ));
      } else if (paragraph.startsWith('```')) {
        // Code blocks
        final code = paragraph.replaceAll('```', '').trim();
        spans.add(TextSpan(
          children: [
            const TextSpan(text: '\n'),
            TextSpan(
              text: code,
              style: const TextStyle(
                color: Color(0xFF85E89D),
                fontFamily: 'monospace',
                fontSize: 14,
                backgroundColor: Color(0xFF2D333B),
                height: 1.5,
                letterSpacing: 0.5,
              ),
            ),
            const TextSpan(text: '\n'),
          ],
        ));
      } else if (paragraph.contains('|')) {
        // Tables
        final rows = paragraph.split('\n');
        for (var i = 0; i < rows.length; i++) {
          final row = rows[i];
          spans.add(TextSpan(
            text: row,
            style: TextStyle(
              color: i == 0 ? Colors.white : const Color(0xFFD1D5DB), // Header row in white
              fontFamily: 'monospace',
              fontSize: 14,
              height: 1.5,
              fontWeight: i == 0 ? FontWeight.bold : FontWeight.normal,
            ),
          ));
          if (i < rows.length - 1) {
            spans.add(const TextSpan(text: '\n'));
          }
        }
      } else {
        // Regular text with bold and italic formatting
        String processedText = paragraph;
        List<TextSpan> inlineSpans = [];

        // Split text by bold and italic markers
        final segments = processedText.split(RegExp(r'(\*\*.*?\*\*|\*.*?\*)'));

        for (var segment in segments) {
          if (segment.startsWith('**') && segment.endsWith('**')) {
            // Bold text
            inlineSpans.add(TextSpan(
              text: segment.substring(2, segment.length - 2),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ));
          } else if (segment.startsWith('*') && segment.endsWith('*')) {
            // Italic text
            inlineSpans.add(TextSpan(
              text: segment.substring(1, segment.length - 1),
              style: const TextStyle(
                color: Color(0xFFD1D5DB),
                fontStyle: FontStyle.italic,
              ),
            ));
          } else {
            // Regular text
            inlineSpans.add(TextSpan(
              text: segment,
              style: const TextStyle(
                color: Color(0xFFD1D5DB),
              ),
            ));
          }
        }

        spans.add(TextSpan(
          children: inlineSpans,
          style: const TextStyle(
            height: 1.5,
            fontSize: 16,
          ),
        ));
      }

      // Add newline after each paragraph
      spans.add(const TextSpan(text: '\n\n'));
    }

    return spans;
  }

  Widget _buildMessageBubble(BuildContext context, String text, {required bool isUser}) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
          minWidth: 100,
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isUser ? Theme.of(context).primaryColor : const Color(0xFF444654),
            borderRadius: BorderRadius.circular(12),
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
                SelectableText.rich(
                  TextSpan(children: _processText(text)),
                  style: const TextStyle(
                    color: Color(0xFFD1D5DB),
                    fontSize: 16,
                  ),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: TypeWriterText(
                    maintainSize: true,
                    repeat: false,
                    text: Text(
                      text,
                      style: const TextStyle(
                        color: Color(0xFFD1D5DB),
                        fontSize: 16,
                      ),
                    ),
                    duration: const Duration(milliseconds: 1),
                    onFinished: (String value) {
                      setState(() => _showFullText = true);
                    },
                  ),
                ),
              if (!isUser) ...[
                const Divider(color: Color(0xFF4D4D4D)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20, color: Color(0xFFD1D5DB)),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: text));
                        Utils.flushBarSuccessMessage('Copied to clipboard', context);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.share, size: 20, color: Color(0xFFD1D5DB)),
                      onPressed: widget.onShare,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, size: 20, color: Color(0xFFD1D5DB)),
                      onPressed: () => widget.onDelete?.call(),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
