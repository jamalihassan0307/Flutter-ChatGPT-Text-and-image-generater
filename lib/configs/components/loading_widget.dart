import 'package:flutter/material.dart';
import 'package:flutter_chatgpt_text_and_image_processing/data/providers/theme_settings_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingWidget extends StatelessWidget {
  final WidgetRef ref;

  const LoadingWidget({super.key, required this.ref});

  @override
  Widget build(BuildContext context) {
    final themeSettings = ref.watch(themeSettingsProvider);
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(themeSettings.primaryColor),
    );
  }
}
