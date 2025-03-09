import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chatgpt_text_and_image_processing/configs/utils.dart';
import 'package:flutter_chatgpt_text_and_image_processing/data/models/theme_settings.dart';
import 'package:typewritertext/typewritertext.dart';
import '../../../models/chat_message.dart';

class ChatMessageBubble extends StatefulWidget {
  final ChatMessage message;
  final VoidCallback onShare;
  final VoidCallback? onDelete;
  final bool isNewMessage;
  final ThemeSettings themeSettings;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.onShare,
    this.onDelete,
    this.isNewMessage = false,
    required this.themeSettings,
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
            color: isUser
                ? widget.themeSettings.userBubbleColor.withOpacity(0.9)
                : widget.themeSettings.systemBubbleColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isUser)
                SelectableText(
                  text,
                  style: TextStyle(color: widget.themeSettings.textColor),
                )
              else if (_showFullText)
                SelectableText.rich(
                  TextSpan(children: _processText(text, context)),
                  style: TextStyle(
                    color: widget.themeSettings.textColor,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: TypeWriterText(
                    maintainSize: true,
                    repeat: false,
                    text: Text(
                      text,
                      style: TextStyle(
                        color: widget.themeSettings.textColor,
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
                Divider(color: widget.themeSettings.textColorSecondary.withOpacity(0.3)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.copy, size: 20, color: widget.themeSettings.textColor),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: text));
                        Utils.flushBarSuccessMessage('Copied to clipboard', context);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.share, size: 20, color: widget.themeSettings.textColor),
                      onPressed: widget.onShare,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, size: 20, color: widget.themeSettings.textColor),
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

  List<InlineSpan> _processText(String text, BuildContext context) {
    final List<InlineSpan> spans = [];
    final paragraphs = text.split('\n\n');

    for (final paragraph in paragraphs) {
      if (paragraph.startsWith('```')) {
        // Code blocks handling
        final match = RegExp(r'```(\w*)\n([\s\S]*?)```').firstMatch(paragraph);
        if (match != null) {
          final language = match.group(1) ?? 'plaintext';
          final code = _escapeHtml(match.group(2) ?? '');

          spans.add(TextSpan(
            children: [
              const TextSpan(text: '\n'),
              WidgetSpan(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D333B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF444C56)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Color(0xFF444C56)),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              language,
                              style: const TextStyle(
                                color: Color(0xFF8B949E),
                                fontSize: 12,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 16, color: Color(0xFF8B949E)),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: code));
                                Utils.flushBarSuccessMessage('Code copied to clipboard', context);
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: SelectableText(
                          code,
                          style: const TextStyle(
                            color: Color(0xFF85E89D),
                            fontFamily: 'monospace',
                            fontSize: 14,
                            height: 1.5,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const TextSpan(text: '\n'),
            ],
          ));
        }
      } else {
        // Process regular text with formatting
        List<TextSpan> inlineSpans = [];
        String currentText = paragraph;

        // Process bold text first
        final boldMatches = RegExp(r'\*\*(.*?)\*\*').allMatches(currentText).toList();
        int lastEnd = 0;

        if (boldMatches.isNotEmpty) {
          for (var match in boldMatches) {
            // Add text before the bold part
            if (match.start > lastEnd) {
              inlineSpans.add(TextSpan(
                text: currentText.substring(lastEnd, match.start),
                style: const TextStyle(color: Color(0xFFD1D5DB)),
              ));
            }

            // Add the bold text
            inlineSpans.add(TextSpan(
              text: match.group(1),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ));

            lastEnd = match.end;
          }

          // Add remaining text
          if (lastEnd < currentText.length) {
            inlineSpans.add(TextSpan(
              text: currentText.substring(lastEnd),
              style: const TextStyle(color: Color(0xFFD1D5DB)),
            ));
          }
        } else {
          // If no bold text, process as regular text
          inlineSpans.add(TextSpan(
            text: currentText,
            style: const TextStyle(color: Color(0xFFD1D5DB)),
          ));
        }

        spans.add(TextSpan(
          children: inlineSpans,
          style: const TextStyle(
            height: 1.5,
            fontSize: 16,
          ),
        ));
      }

      spans.add(const TextSpan(text: '\n\n'));
    }

    return spans;
  }

  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;')
        .trim();
  }
}
