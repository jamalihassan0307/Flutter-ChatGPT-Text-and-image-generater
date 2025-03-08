import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiApiService {
  final Dio _dio = Dio();
  final String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models';
  final String _model = 'gemini-1.0-pro';
  
  GeminiApiService() {
    _dio.options.headers['Content-Type'] = 'application/json';
  }

  Future<Map<String, dynamic>> generateContent(String prompt) async {
    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      final response = await _dio.post(
        '$_baseUrl/$_model:generateContent?key=$apiKey',
        data: {
          'contents': [{
            'parts': [{'text': prompt}]
          }]
        },
      );
      return response.data;
    } catch (e) {
      throw Exception('Failed to generate content: $e');
    }
  }
} 