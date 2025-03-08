import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/chat.dart';
import '../../../providers/chat_provider.dart';

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
                        onTap: () {
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
                                      ref.read(chatProvider.notifier).renameChat(
                                            chat.id,
                                            controller.text,
                                          );
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Text('Rename'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      PopupMenuItem(
                        child: const Text('Delete'),
                        onTap: () {
                          ref.read(chatProvider.notifier).deleteChat(chat.id);
                        },
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
} 