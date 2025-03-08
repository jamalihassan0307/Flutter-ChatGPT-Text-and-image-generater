import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiApiService {
  final Dio _dio = Dio();
  final String _baseUrl;
  final String _model = 'gemini-2.0-flash';
  final String? _apiKey;
  
  GeminiApiService() : 
    _baseUrl = dotenv.env['GEMINI_BASE_URL'] ?? 'https://generativelanguage.googleapis.com/v1beta',
    _apiKey = dotenv.env['GEMINI_API_KEY'] {
    _dio.options.headers['Content-Type'] = 'application/json';
    
    // Add logging interceptor
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) {
        debugPrint('🌐 API Log: $obj');
      },
    ));
    
    if (_apiKey == null) {
      debugPrint('Warning: GEMINI_API_KEY not found in environment variables');
    }
  }

  Future<Map<String, dynamic>> generateContent(String prompt) async {
    if (_apiKey == null) {
      throw Exception('API key not configured. Please add GEMINI_API_KEY to your .env file');
    }

    try {
      debugPrint('🚀 Sending request to Gemini API...');
      debugPrint('📝 Prompt: $prompt');
      
      final url = '$_baseUrl/models/$_model:generateContent?key=$_apiKey';
      final data = {
        'contents': [{
          'parts': [{'text': prompt}]
        }],
        'generationConfig': {
          'temperature': 0.7,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 1024,
        },
        'safetySettings': [
          {
            'category': 'HARM_CATEGORY_HARASSMENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_HATE_SPEECH',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          },
          {
            'category': 'HARM_CATEGORY_DANGEROUS_CONTENT',
            'threshold': 'BLOCK_MEDIUM_AND_ABOVE'
          }
        ]
      };

      debugPrint('🔗 URL: $url');
      debugPrint('📦 Request Data: $data');

      final response = await _dio.post(url, data: data);
      
      debugPrint('✅ Response received:');
      debugPrint('📄 Response Data: ${response.data}');

      return response.data;
    } catch (e) {
      debugPrint('❌ API Error: $e');
      if (e is DioException) {
        debugPrint('🔍 Response Status: ${e.response?.statusCode}');
        debugPrint('📄 Response Data: ${e.response?.data}');
        
        if (e.response?.statusCode == 401 || e.response?.statusCode == 403) {
          throw Exception('Invalid API key. Please check your GEMINI_API_KEY in .env file');
        }
      }
      throw Exception('Failed to generate content: $e');
    }
  }
} 