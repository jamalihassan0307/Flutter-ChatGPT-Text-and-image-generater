import 'package:flutter/material.dart';
import '../../data/view/splash/splash_screen.dart';
import '../../data/view/auth/login_screen.dart';
import '../../data/view/auth/signup_screen.dart';
import 'routes_name.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.splash:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SplashScreen(),
        );
      case RoutesName.login:
        return MaterialPageRoute(
          builder: (BuildContext context) => const LoginScreen(),
        );
      case RoutesName.signup:
        return MaterialPageRoute(
          builder: (BuildContext context) => const SignupScreen(),
        );
      default:
        return MaterialPageRoute(builder: (_) {
          return const Scaffold(
            body: Center(
              child: Text('No route defined'),
            ),
          );
        });
    }
  }
}

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
