import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GeminiApiService {
  final String _baseUrl = dotenv.env['GEMINI_BASE_URL'] ?? '';
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? '';

  Future<Map<String, dynamic>> generateContent(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/models/gemini-1.5-flash:generateContent?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
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
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to generate content: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
} 