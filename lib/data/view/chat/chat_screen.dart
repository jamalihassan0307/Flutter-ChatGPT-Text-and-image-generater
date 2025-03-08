import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:markdown_widget/markdown_widget.dart';
import '../../../configs/utils.dart';
import '../../providers/chat_provider.dart';
import 'widgets/chat_drawer.dart';
import 'widgets/chat_input.dart';
import 'widgets/chat_message_bubble.dart';
import '../../../configs/components/loading_widget.dart';
import '../../../configs/constants/app_images.dart';
import '../../../configs/theme/app_theme.dart';

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
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    _scrollController.addListener(() {
      if (_scrollController.hasClients) {
        final showButton = _scrollController.position.pixels < _scrollController.position.maxScrollExtent - 300;
        if (showButton != _showScrollToBottom) {
          setState(() => _showScrollToBottom = showButton);
        }
      }
    });
  }

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
                ? _buildWelcomeScreen()
                : Stack(
                    children: [
                      // Background Image
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: '${AppImages.chatBg}?auto=format&fit=crop&w=800&q=80',
                          fit: BoxFit.cover,
                          color: Colors.black.withOpacity(0.7),
                          colorBlendMode: BlendMode.darken,
                          placeholder: (context, url) => Container(
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                      // Chat Messages
                      ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: currentChat.messages.length + (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == currentChat.messages.length) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.7,
                              alignment: Alignment.center,
                              child: const LoadingWidget(),
                            );
                          }
                          final message = currentChat.messages[index];
                          return ChatMessageBubble(
                            message: message,
                            onShare: () => Utils.share(message.response),
                            onDelete: () {
                              ref.read(chatProvider.notifier).deleteMessage(
                                    currentChat.id,
                                    message.id,
                                  );
                            },
                            isNewMessage: index == currentChat.messages.length - 1 && _isLoading,
                          );
                        },
                      ),
                      if (_showScrollToBottom)
                        Positioned(
                          right: 16,
                          bottom: 80,
                          child: FloatingActionButton(
                            mini: true,
                            onPressed: _scrollToBottom,
                            child: const Icon(Icons.arrow_downward),
                          ),
                        ),
                    ],
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

  Widget _buildWelcomeScreen() {
    return Stack(
      children: [
        // Background Image
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: '${AppImages.aiBackground}?auto=format&fit=crop&w=800&q=80',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.6),
            colorBlendMode: BlendMode.darken,
          ),
        ),
        // Content
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                AppImages.appLogo,
                height: 120,
              ),
              const SizedBox(height: 24),
              Text(
                'Welcome to Gemini AI',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                'Start a conversation with AI',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _handleNewChat,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text(
                  'Start a new chat',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ],
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
