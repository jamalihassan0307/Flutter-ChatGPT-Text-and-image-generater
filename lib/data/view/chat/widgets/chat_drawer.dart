import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_text_and_image_processing/configs/constants/app_images.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chatgpt_text_and_image_processing/data/models/chat.dart';
// import 'package:flutter_chatgpt_text_and_image_processing/data/providers/chat_provider.dart';
import 'package:flutter_chatgpt_text_and_image_processing/data/providers/theme_settings_provider.dart';
// import 'package:flutter_chatgpt_text_and_image_processing/data/utils/app_images.dart';

class ChatDrawer extends ConsumerWidget {
  final List<Chat> chats;
  final String? selectedChatId;
  final Function(String) onChatSelected;

  const ChatDrawer({
    super.key,
    required this.chats,
    required this.selectedChatId,
    required this.onChatSelected,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeSettingsProvider);

    return Drawer(
      backgroundColor: themeSettings.systemBubbleColor,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: themeSettings.systemBubbleColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  AppImages.appLogo,
                  height: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  'Gemini AI',
                  style: TextStyle(
                    color: themeSettings.textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                final isSelected = chat.id == selectedChatId;

                return ListTile(
                  selected: isSelected,
                  selectedTileColor: themeSettings.primaryColor.withOpacity(0.2),
                  leading: Icon(
                    Icons.chat_bubble_outline,
                    color: isSelected ? themeSettings.primaryColor : themeSettings.textColorSecondary,
                  ),
                  title: Text(
                    chat.name,
                    style: TextStyle(
                      color: isSelected ? themeSettings.primaryColor : themeSettings.textColor,
                    ),
                  ),
                  subtitle: Text(
                    '${chat.messages.length} messages',
                    style: TextStyle(
                      color: themeSettings.textColorSecondary,
                    ),
                  ),
                  onTap: () => onChatSelected(chat.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
