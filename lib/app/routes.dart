import 'package:flutter/material.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/splash/screen/splash_screen.dart';
import '../features/onboarding/screen/onboarding1.dart';
import '../features/onboarding/screen/onboarding2.dart';
import '../features/onboarding/screen/onboarding3.dart';
import '../features/home/screen/home_screen_costumer.dart';
import '../features/home/screen/home_screen_booth.dart';

class AppRoutes {
  AppRoutes._();
  static const splash = "/";
  static const login = "/login";
  static const register = "/register";
  static const onboarding1 = "/onboarding1";
  static const onboarding2 = "/onboarding2";
  static const onboarding3 = "/onboarding3";
  static const homecostumer = "/home_costumer";
  static const homebooth = "/home_booth";

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

      case onboarding1:
        return MaterialPageRoute(
          builder: (_) => OnboardingScreen1(),
        );

      case onboarding2:
        return MaterialPageRoute(
          builder: (_) => OnboardingScreen2(),
        );

      case onboarding3:
        return MaterialPageRoute(
          builder: (_) => OnboardingScreen3(),
        );

      case homecostumer:
        return MaterialPageRoute(
          builder: (_) => HomeScreenCostumer(),
        );

      case homebooth:
        return MaterialPageRoute(
          builder: (_) => HomeScreenBooth(),
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