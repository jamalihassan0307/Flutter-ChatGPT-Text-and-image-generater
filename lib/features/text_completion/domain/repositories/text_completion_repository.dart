import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/data/model/text_completion_model.dart';

abstract class TextCompletionRepository {
  Future<TextCompletionModel> getTextCompletion(String query);
}
