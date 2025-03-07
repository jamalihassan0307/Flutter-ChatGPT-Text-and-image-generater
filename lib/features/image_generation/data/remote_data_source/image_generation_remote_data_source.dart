import 'package:flutter_chatgpt_text_and_image_processing/features/image_generation/data/model/image_generation_model.dart';

abstract class ImageGenerationRemoteDataSource {
  Future<ImageGenerationModel> getGenerateImages(String query);
}
