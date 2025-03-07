import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/global/search_text_field/search_text_field_widget.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/data/models/chat_message.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/presentation/cubit/text_completion_cubit.dart';
import '../widgets/chat_drawer.dart';
import '../../data/services/database_service.dart';

class TextCompletionPage extends StatefulWidget {
  const TextCompletionPage({Key? key}) : super(key: key);

  @override
  State<TextCompletionPage> createState() => _TextCompletionPageState();
}

class _TextCompletionPageState extends State<TextCompletionPage> {
  TextEditingController _searchTextController = TextEditingController();
  final DatabaseService _db = DatabaseService();
  int? _currentConversationId;

  @override
  void initState() {
    _searchTextController.addListener(() {
      setState(() {});
    });
    super.initState();
    _createNewChat();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  Future<void> _createNewChat() async {
    final conversation = await _db.createConversation('New Chat');
    setState(() {
      _currentConversationId = conversation.id;
    });
  }

  Widget _buildFormattedText(String text) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[100],
              height: 1.5,
            ),
          ),
          Divider(color: Colors.grey[700]),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                DateTime.now().toString().substring(0, 16),
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gemini Text Completion"),
      ),
      drawer: ChatDrawer(
        currentConversationId: _currentConversationId,
        onConversationSelected: (id) {
          setState(() => _currentConversationId = id);
          Navigator.pop(context);
        },
        onNewChat: () {
          _createNewChat();
          Navigator.pop(context);
        },
      ),
      body: _currentConversationId == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: FutureBuilder<List<ChatMessage>>(
                    future: _db.getMessages(_currentConversationId!),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final messages = snapshot.data!;
                      return ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildQueryBubble(message.query),
                              _buildResponseBubble(message.response),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                SearchTextFieldWidget(
                  textEditingController: _searchTextController,
                  onTap: () {
                    if (_searchTextController.text.isNotEmpty) {
                      final query = _searchTextController.text;
                      BlocProvider.of<TextCompletionCubit>(context)
                          .textCompletion(
                            query: query,
                            conversationId: _currentConversationId!,
                          )
                          .then((value) => _clearTextField());
                    }
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
    );
  }

  Widget _buildQueryBubble(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue[700],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildResponseBubble(String text) {
    return _buildFormattedText(text);
  }

  void _clearTextField() {
    setState(() {
      _searchTextController.clear();
    });
  }
}
