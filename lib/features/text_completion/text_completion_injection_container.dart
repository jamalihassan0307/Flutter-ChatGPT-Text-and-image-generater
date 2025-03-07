import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/data/remote_data_source/text_completion_remote_data_source.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/data/remote_data_source/text_completion_remote_data_source_impl.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/data/repositories/text_completion_repository_impl.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/domain/repositories/text_completion_repository.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/domain/usecases/text_completion_usecase.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/presentation/cubit/text_completion_cubit.dart';
import 'package:flutter_chatgpt_text_and_image_processing/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> textCompletionInjectionContainer() async {
  final prefs = await SharedPreferences.getInstance();
  
  sl.registerLazySingleton(() => ChatStorageService(prefs));
  
  sl.registerFactory<TextCompletionCubit>(
    () => TextCompletionCubit(sl()),
  );
}
