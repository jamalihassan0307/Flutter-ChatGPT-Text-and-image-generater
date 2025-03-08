import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiApiService {
  // Move these to a secure config or environment service
  static const String _baseUrl = String.fromEnvironment(
    'GEMINI_BASE_URL',
    defaultValue: 'https://generativelanguage.googleapis.com/v1beta',
  );
  static const String _apiKey = String.fromEnvironment('GEMINI_API_KEY');

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