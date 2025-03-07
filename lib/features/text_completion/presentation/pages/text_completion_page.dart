import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/global/search_text_field/search_text_field_widget.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/presentation/cubit/text_completion_cubit.dart';
import 'package:share_plus/share_plus.dart';

class TextCompletionPage extends StatefulWidget {
  const TextCompletionPage({Key? key}) : super(key: key);

  @override
  State<TextCompletionPage> createState() => _TextCompletionPageState();
}

class _TextCompletionPageState extends State<TextCompletionPage> {
  TextEditingController _searchTextController = TextEditingController();

  @override
  void initState() {
    _searchTextController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
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
      body: Center(
        child: Column(children: [
          Expanded(
            child: BlocBuilder<TextCompletionCubit, TextCompletionState>(
              builder: (context, textCompletionState) {
                if (textCompletionState is TextCompletionLoading) {
                  return Center(
                    child: Container(width: 300, height: 300, child: Image.asset("assets/loading.gif")),
                  );
                }
                if (textCompletionState is TextCompletionLoaded) {
                  final response = textCompletionState.geminiResponse;
                  if (response.candidates.isEmpty) {
                    return Center(child: Text("No response generated"));
                  }

                  return ListView.builder(
                    itemCount: response.candidates.length,
                    itemBuilder: (BuildContext context, int index) {
                      final text = response.candidates[index].content.parts.first.text;
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildFormattedText(text),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.share),
                                    onPressed: () => Share.share(text),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.copy),
                                    onPressed: () => Clipboard.setData(ClipboardData(text: text)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                if (textCompletionState is TextCompletionError) {
                  return Center(child: Text(textCompletionState.message));
                }
                return Center(
                    child: Text(
                  "Gemini Text Completion",
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ));
              },
            ),
          ),
          SearchTextFieldWidget(
              textEditingController: _searchTextController,
              onTap: () {
                if (_searchTextController.text.isNotEmpty) {
                  BlocProvider.of<TextCompletionCubit>(context)
                      .textCompletion(query: _searchTextController.text)
                      .then((value) => _clearTextField());
                }
              }),
          SizedBox(height: 20),
        ]),
      ),
    );
  }

  void _clearTextField() {
    setState(() {
      _searchTextController.clear();
    });
  }
}
