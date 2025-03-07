//private endPoint Engine
import 'package:flutter_chatgpt_text_and_image_processing/core/open_ai_data.dart';

String endPoint(String endPoint) => "$baseURL/$endPoint";

Map<String, String> headerBearerOption(String token) => {
      "Content-Type": "application/json",
      'Authorization': 'Bearer $token',
    };
