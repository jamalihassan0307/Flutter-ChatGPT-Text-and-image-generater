import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chatgpt_text_and_image_processing/core/gemini_config.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/data/models/gemini_response_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/data/models/chat_message.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/data/services/chat_storage_service.dart';

part 'text_completion_state.dart';

class TextCompletionCubit extends Cubit<TextCompletionState> {
  final ChatStorageService _storage;

  TextCompletionCubit(this._storage) : super(TextCompletionInitial());

  Future<void> textCompletion({
    required String query,
    required int conversationId,
  }) async {
    emit(TextCompletionLoading());
    try {
      final response = await http.post(
        Uri.parse('${GeminiConfig.baseUrl}/models/${GeminiConfig.model}:generateContent?key=${GeminiConfig.apiKey}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': query}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final geminiResponse = GeminiResponseModel.fromJson(json.decode(response.body));
        if (geminiResponse.candidates.isNotEmpty) {
          final responseText = geminiResponse.candidates.first.content.parts.first.text;
          await _storage.saveMessage(ChatMessage(
            query: query,
            response: responseText,
            timestamp: DateTime.now(),
            conversationId: conversationId,
          ));
        }
        emit(TextCompletionLoaded(geminiResponse));
      } else {
        emit(TextCompletionError(message: 'Error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(TextCompletionError(message: e.toString()));
    }
  }

  Future<List<ChatMessage>> getChatHistory(int conversationId) async {
    return await _storage.getMessages(conversationId);
  }
}
