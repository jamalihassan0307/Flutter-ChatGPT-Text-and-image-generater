import 'package:flutter/material.dart';
import '../../../models/chat.dart';

class ChatDrawer extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Center(
              child: Text(
                'Conversations',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  title: Text(
                    chat.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  selected: chat.id == selectedChatId,
                  leading: const Icon(Icons.chat_bubble_outline),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: const Text('Rename'),
                        onTap: () => _showRenameDialog(context, chat),
                      ),
                      PopupMenuItem(
                        child: const Text('Delete'),
                        onTap: () => _showDeleteDialog(context, chat),
                      ),
                    ],
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

  void _showRenameDialog(BuildContext context, Chat chat) {
    final controller = TextEditingController(text: chat.name);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Chat'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Chat Name',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                // TODO: Implement rename
                Navigator.pop(context);
              }
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Chat chat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Chat'),
        content: Text('Are you sure you want to delete "${chat.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // TODO: Implement delete
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
} 