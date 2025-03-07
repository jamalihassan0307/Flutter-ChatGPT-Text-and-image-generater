import 'package:flutter/material.dart';
import '../../data/models/chat_conversation.dart';
import '../../data/services/database_service.dart';

class ChatDrawer extends StatefulWidget {
  final int? currentConversationId;
  final Function(int) onConversationSelected;
  final Function() onNewChat;

  const ChatDrawer({
    Key? key,
    this.currentConversationId,
    required this.onConversationSelected,
    required this.onNewChat,
  }) : super(key: key);

  @override
  State<ChatDrawer> createState() => _ChatDrawerState();
}

class _ChatDrawerState extends State<ChatDrawer> {
  final DatabaseService _db = DatabaseService();
  List<ChatConversation> _conversations = [];

  @override
  void initState() {
    super.initState();
    _loadConversations();
  }

  Future<void> _loadConversations() async {
    final conversations = await _db.getConversations();
    setState(() {
      _conversations = conversations;
    });
  }

  Future<void> _editTitle(ChatConversation conversation) async {
    final controller = TextEditingController(text: conversation.title);
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Chat Name'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'Enter new name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _db.updateConversationTitle(
                conversation.id!,
                controller.text,
              );
              Navigator.pop(context);
              _loadConversations();
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
              child: Text(
                'Chat History',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('New Chat'),
            onTap: widget.onNewChat,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                final conversation = _conversations[index];
                return ListTile(
                  selected: widget.currentConversationId == conversation.id,
                  title: Text(conversation.title),
                  subtitle: Text(
                    conversation.updatedAt.toString().substring(0, 16),
                  ),
                  onTap: () => widget.onConversationSelected(conversation.id!),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text('Edit'),
                        onTap: () => _editTitle(conversation),
                      ),
                      PopupMenuItem(
                        child: Text('Delete'),
                        onTap: () async {
                          await _db.deleteConversation(conversation.id!);
                          _loadConversations();
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 