import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_chatgpt_text_and_image_processing/core/gemini_config.dart';

class GeminiService {
  Future<String> generateText(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('${GeminiConfig.baseUrl}/models/${GeminiConfig.model}:generateContent?key=${GeminiConfig.apiKey}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception('Failed to generate text');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<String> generateContentFromImage(String imageBase64, String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('${GeminiConfig.baseUrl}/models/${GeminiConfig.model}:generateContent?key=${GeminiConfig.apiKey}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {
                  'inlineData': {'mimeType': 'image/jpeg', 'data': imageBase64}
                },
                {'text': prompt}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        throw Exception('Failed to generate content from image');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
