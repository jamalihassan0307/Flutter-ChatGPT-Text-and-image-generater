import 'package:flutter_chatgpt_text_and_image_processing/features/image_generation/image_generation_injection_container.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/text_completion_injection_container.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'features/text_completion/data/services/gemini_api_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final http.Client httpClient = http.Client();

  sl.registerLazySingleton<http.Client>(() => httpClient);

  sl.registerLazySingleton(() => GeminiApiService());

  await textCompletionInjectionContainer();
  await imageGenerationInjectionContainer();
}
