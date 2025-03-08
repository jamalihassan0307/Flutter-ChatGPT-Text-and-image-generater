import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_text_and_image_processing/data/models/theme_settings.dart';

class ChatInput extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final bool isLoading;
  final ThemeSettings themeSettings;

  const ChatInput({
    super.key,
    required this.controller,
    required this.onSend,
    this.isLoading = false,
    required this.themeSettings,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: themeSettings.systemBubbleColor.withOpacity(0.9),
        border: Border(
          top: BorderSide(
            color: themeSettings.primaryColor.withOpacity(0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              enabled: !isLoading,
              style: TextStyle(color: themeSettings.textColor),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: TextStyle(color: themeSettings.textColorSecondary),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              minLines: 1,
              maxLines: 5,
              onSubmitted: (_) => onSend(),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send, color: themeSettings.textColor),
            onPressed: isLoading ? null : onSend,
          ),
        ],
      ),
    );
  }
}
