import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiApiService {
  final Dio _dio = Dio();
  final String _baseUrl;
  final String _model = 'gemini-2.0-flash';
  final String? _apiKey;

  GeminiApiService()
      : _baseUrl = dotenv.env['GEMINI_BASE_URL'] ?? 'https://generativelanguage.googleapis.com/v1beta',
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

  String _formatResponse(Map<String, dynamic> response) {
    try {
      final text = response['candidates'][0]['content']['parts'][0]['text'] as String;

      // Split into sections by double newlines
      final sections = text.split('\n\n');
      final formattedSections = <String>[];

      for (var section in sections) {
        // Format headings
        if (section.startsWith('Key') || section.contains('Definition') || section.contains('Overview')) {
          section = '# $section';
        } else if (section.startsWith('Types') || section.startsWith('Features') || section.startsWith('Components')) {
          section = '## $section';
        } else if (section.startsWith('Example') || section.startsWith('Note')) {
          section = '### $section';
        }

        // Format lists
        if (section.contains('\n-') || section.contains('\n•')) {
          final lines = section.split('\n');
          for (var i = 0; i < lines.length; i++) {
            if (lines[i].startsWith('-') || lines[i].startsWith('•')) {
              lines[i] = '* ${lines[i].substring(1).trim()}';
            }
          }
          section = lines.join('\n');
        }

        // Format code blocks
        if (section.contains('```')) {
          section = section.replaceAll('```', '\n```\n');
        }

        // Format tables
        if (section.contains('|')) {
          final lines = section.split('\n');
          if (lines.length > 1) {
            lines.insert(1, '|${'-' * (lines[0].length - 2)}|');
            section = lines.join('\n');
          }
        }

        // Format bold terms
        final terms = [
          'database',
          'data',
          'storage',
          'information',
          'system',
          'query',
          'table',
          'record',
          'field',
          'key',
          'index',
          'transaction',
          'SQL',
          'NoSQL',
          'schema'
        ];
        for (final term in terms) {
          final regex = RegExp(r'\b' + term + r'\b', caseSensitive: false);
          section = section.replaceAllMapped(regex, (match) => '**${match[0]}**');
        }

        formattedSections.add(section);
      }

      return formattedSections.join('\n\n');
    } catch (e) {
      debugPrint('Error formatting response: $e');
      return response['candidates'][0]['content']['parts'][0]['text'] as String;
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
        'contents': [
          {
            'parts': [
              {'text': prompt}
            ]
          }
        ],
        'generationConfig': {
          'temperature': 0.7,
          'topK': 40,
          'topP': 0.95,
          'maxOutputTokens': 1024,
        },
        'safetySettings': [
          {'category': 'HARM_CATEGORY_HARASSMENT', 'threshold': 'BLOCK_MEDIUM_AND_ABOVE'},
          {'category': 'HARM_CATEGORY_HATE_SPEECH', 'threshold': 'BLOCK_MEDIUM_AND_ABOVE'},
          {'category': 'HARM_CATEGORY_SEXUALLY_EXPLICIT', 'threshold': 'BLOCK_MEDIUM_AND_ABOVE'},
          {'category': 'HARM_CATEGORY_DANGEROUS_CONTENT', 'threshold': 'BLOCK_MEDIUM_AND_ABOVE'}
        ]
      };

      debugPrint('🔗 URL: $url');
      debugPrint('📦 Request Data: $data');

      final response = await _dio.post(url, data: data);

      // Format the response text
      final formattedResponse = _formatResponse(response.data);

      // Update the response with formatted text
      response.data['candidates'][0]['content']['parts'][0]['text'] = formattedResponse;

      debugPrint('✅ Response received:');
      debugPrint('📄 Formatted Response: $formattedResponse');

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
