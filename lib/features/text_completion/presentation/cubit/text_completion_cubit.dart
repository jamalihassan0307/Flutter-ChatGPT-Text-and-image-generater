import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_chatgpt_text_and_image_processing/core/custom_exceptions.dart';
import 'package:flutter_chatgpt_text_and_image_processing/core/gemini_config.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/data/model/text_completion_model.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/data/models/gemini_response_model.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/domain/usecases/text_completion_usecase.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/data/models/chat_message.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/data/services/chat_storage_service.dart';

part 'text_completion_state.dart';

class TextCompletionCubit extends Cubit<TextCompletionState> {
  final ChatStorageService _storage;

  TextCompletionCubit(this._storage) : super(TextCompletionInitial());

  Future<void> textCompletion({required String query}) async {
    emit(TextCompletionLoading());
    try {
      final response = await http.post(
        Uri.parse('${GeminiConfig.baseUrl}/models/${GeminiConfig.model}:generateContent?key=${GeminiConfig.apiKey}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [{
            'parts': [{'text': query}]
          }]
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

  Future<List<ChatMessage>> getChatHistory() async {
    return await _storage.getMessages();
  }
}
