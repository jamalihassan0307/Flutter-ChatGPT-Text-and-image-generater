import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chatgpt_text_and_image_processing/core/http_certificate_maneger.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/app/home/home_page.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/app/routes/on_generate_route.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/app/splash/splash_screen.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/image_generation/presentation/cubit/image_generation_cubit.dart';
import 'package:flutter_chatgpt_text_and_image_processing/features/text_completion/presentation/cubit/text_completion_cubit.dart';
import 'injection_container.dart' as di;
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = new MyHttpOverrides();
  await di.init();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TextCompletionCubit>(
          create: (_) => di.sl<TextCompletionCubit>(),
        ),
        BlocProvider<ImageGenerationCubit>(
          create: (_) => di.sl<ImageGenerationCubit>(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ChatGPT',
        onGenerateRoute: OnGenerateRoute.route,
        theme: ThemeData(brightness: Brightness.dark),
        initialRoute: '/',
        routes: {
          "/": (context) {
            return const SplashScreen(
              child: HomePage(),
            );
          }
        },
      ),
    );
  }
}
