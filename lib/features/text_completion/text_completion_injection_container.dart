import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/data/services/chat_storage_service.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/data/services/database_service.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/presentation/cubit/text_completion_cubit.dart';
import 'package:flutter_chatgpt_text_and_image_processing/injection_container.dart';
// import 'package:shared_preferences/shared_preferences.dart';

Future<void> textCompletionInjectionContainer() async {
  // final prefs = await SharedPreferences.getInstance();

  sl.registerLazySingleton(() => DatabaseService());
  sl.registerLazySingleton(() => ChatStorageService(sl()));

  sl.registerFactory<TextCompletionCubit>(
    () => TextCompletionCubit(sl()),
  );
}
