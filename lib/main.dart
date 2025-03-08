import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'configs/routes/routes.dart';
import 'configs/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'data/providers/app_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Error loading .env file: $e');
    // Set default values or handle the error appropriately
    dotenv.env['GEMINI_API_KEY'] = 'AIzaSyDG93475838urtuhrg35';
    dotenv.env['GEMINI_BASE_URL'] = 'https://generativelanguage.googleapis.com/v1beta';
  }

  final prefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemini AI',
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFF10A37F), // ChatGPT green
        scaffoldBackgroundColor: const Color(0xFF343541), // Dark background
        cardColor: const Color(0xFF444654), // Message bubble background
        dividerColor: const Color(0xFF4D4D4D),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFD1D5DB)),
          bodyMedium: TextStyle(color: Color(0xFFD1D5DB)),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF343541),
          elevation: 0,
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: RoutesName.splash,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
