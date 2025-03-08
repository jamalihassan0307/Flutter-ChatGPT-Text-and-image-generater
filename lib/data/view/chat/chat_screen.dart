import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown_widget/markdown_widget.dart';
import '../../../configs/utils.dart';
import '../../providers/chat_provider.dart';
import 'widgets/chat_drawer.dart';
import 'widgets/chat_input.dart';
import 'widgets/chat_message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  String? _selectedChatId;

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
                ? const Center(
                    child: Text('Start a new chat'),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: currentChat.messages.length,
                    itemBuilder: (context, index) {
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
            onSend: () {
              if (_textController.text.isNotEmpty) {
                if (currentChat == null) {
                  ref
                      .read(chatProvider.notifier)
                      .createChat('New Chat')
                      .then((_) {
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
    ref.read(chatProvider.notifier).sendMessage(chatId, message).then((_) {
      _scrollToBottom();
    }).catchError((error) {
      Utils.flushBarErrorMessage(error.toString(), context);
    });
  }
} 