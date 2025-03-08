import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiApiService {
  final Dio _dio = Dio();
  final String _baseUrl;
  final String _model = 'gemini-1.0-pro';
  final String? _apiKey;
  
  GeminiApiService() : 
    _baseUrl = dotenv.env['GEMINI_BASE_URL'] ?? 'https://generativelanguage.googleapis.com/v1beta',
    _apiKey = dotenv.env['GEMINI_API_KEY'] {
    _dio.options.headers['Content-Type'] = 'application/json';
    
    if (_apiKey == null) {
      debugPrint('Warning: GEMINI_API_KEY not found in environment variables');
    }
  }

  Future<Map<String, dynamic>> generateContent(String prompt) async {
    if (_apiKey == null) {
      throw Exception('API key not configured. Please add GEMINI_API_KEY to your .env file');
    }

    try {
      final response = await _dio.post(
        '$_baseUrl/models/$_model:generateContent?key=$_apiKey',
        data: {
          'contents': [{
            'parts': [{'text': prompt}]
          }]
        },
      );
      return response.data;
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
          throw Exception('Invalid API key. Please check your GEMINI_API_KEY in .env file');
        }
      }
      throw Exception('Failed to generate content: $e');
    }
  }
} 