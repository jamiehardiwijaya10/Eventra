import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/splash/screen/splash_screen.dart';

class AppRoutes {
  AppRoutes._();
  static const splash = "/";
  static const login = "/login";
  static const register = "/register";

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case login:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => RegisterScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text("404 Page Not Found"),
            ),
          ),
        );
    }
  }
}