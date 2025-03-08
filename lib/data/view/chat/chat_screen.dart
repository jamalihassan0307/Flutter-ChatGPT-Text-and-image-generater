import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';
import '../../../configs/utils.dart';
import '../../providers/chat_provider.dart';
import 'widgets/chat_drawer.dart';
import 'widgets/chat_input.dart';
import 'widgets/chat_message_bubble.dart';
import '../../../configs/components/loading_widget.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  String? _selectedChatId;
  bool _isLoading = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _handleNewChat() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Chat'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter chat name',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              ref.read(chatProvider.notifier).createChat(value).then((_) {
                final chats = ref.read(chatProvider);
                if (chats.isNotEmpty) {
                  setState(() => _selectedChatId = chats.last.id);
                }
                Navigator.pop(context);
              });
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              ref.read(chatProvider.notifier).createChat('New Chat').then((_) {
                final chats = ref.read(chatProvider);
                if (chats.isNotEmpty) {
                  setState(() => _selectedChatId = chats.last.id);
                }
                Navigator.pop(context);
              });
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final chats = ref.watch(chatProvider);
    final currentChat = chats.isEmpty
        ? null
        : chats.firstWhere(
            (chat) => chat.id == _selectedChatId,
            orElse: () => chats.first,
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(currentChat?.name ?? 'New Chat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _handleNewChat,
          ),
        ],
      ),
      drawer: ChatDrawer(
        chats: chats,
        selectedChatId: _selectedChatId,
        onChatSelected: (chatId) {
          setState(() => _selectedChatId = chatId);
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: currentChat == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No chats yet'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _handleNewChat,
                          child: const Text('Start a new chat'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: currentChat.messages.length + (_isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == currentChat.messages.length) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: LoadingWidget(),
                        );
                      }
                      final message = currentChat.messages[index];
                      return ChatMessageBubble(
                        message: message,
                        onShare: () => Utils.share(message.response),
                      );
                    },
                  ),
          ),
          ChatInput(
            controller: _textController,
            isLoading: _isLoading,
            onSend: () {
              if (_textController.text.isNotEmpty) {
                if (currentChat == null) {
                  ref.read(chatProvider.notifier).createChat('New Chat').then((_) {
                    final newChat = ref.read(chatProvider).last;
                    setState(() => _selectedChatId = newChat.id);
                    _sendMessage(newChat.id);
                  });
                } else {
                  _sendMessage(currentChat.id);
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _sendMessage(String chatId) {
    final message = _textController.text;
    _textController.clear();
    setState(() => _isLoading = true);

    ref.read(chatProvider.notifier).sendMessage(chatId, message).then((_) {
      _scrollToBottom();
    }).catchError((error) {
      Utils.flushBarErrorMessage(error.toString(), context);
    }).whenComplete(() {
      setState(() => _isLoading = false);
    });
  }
}
