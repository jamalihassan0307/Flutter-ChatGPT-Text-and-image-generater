import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/app/app_const/page_const.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/image_generation/presentation/pages/image_generation_page.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/presentation/pages/text_completion_page.dart';

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case "/":
        {
          return materialBuilder(
            widget: ErrorPage(),
          );
        }
      case PageConst.ImageGenerationPage:
        {
          return materialBuilder(
            widget: const ImageGenerationPage(),
          );
        }
      case PageConst.textCompletionPage:
        {
          return materialBuilder(
            widget: const TextCompletionPage(),
          );
        }
      default:
        return materialBuilder(
          widget: ErrorPage(),
        );
    }
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("error"),
      ),
      body: Center(
        child: Text("error"),
      ),
    );
  }
}

MaterialPageRoute materialBuilder({required Widget widget}) {
  return MaterialPageRoute(builder: (_) => widget);
}
