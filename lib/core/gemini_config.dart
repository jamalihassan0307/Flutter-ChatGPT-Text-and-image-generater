class GeminiConfig {
  static const String baseUrl = 'https://generativelanguage.googleapis.com/v1beta';
  static const String model = 'gemini-1.5-flash';
  static const String apiKey = String.fromEnvironment('GEMINI_API_KEY', defaultValue: 'AIzaSyAsAqrPD5zqjOO_TTQbxTkG9b-ScXm668k');
} 