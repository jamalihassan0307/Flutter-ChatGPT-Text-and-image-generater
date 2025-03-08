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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                text,
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(onTap: () => Share.share(text), child: Icon(Icons.share, size: 35)),
                                  InkWell(
                                      onTap: () => Clipboard.setData(ClipboardData(text: text)),
                                      child: Icon(Icons.copy, size: 35)),
                                ],
                              ),
                              SizedBox(height: 10),
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
