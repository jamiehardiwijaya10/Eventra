import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../app/routes.dart';
import '../../../core/services/auth_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _startSplash();
  }

  Future<void> _startSplash() async {
    await Future.delayed(
      const Duration(seconds: 2),
    );

    if (!mounted) return;

    final prefs = await SharedPreferences.getInstance();

    final hasSeenOnboarding =
        prefs.getBool('has_seen_onboarding') ?? false;

    if (!hasSeenOnboarding) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.onboarding1,
      );
      return;
    }

    if (_authService.isLoggedIn) {
      try {
        await _authService.goToHomeByRole(context);
      } catch (e) {
        debugPrint("AUTO LOGIN ERROR: $e");

        if (!mounted) return;

        Navigator.pushReplacementNamed(
          context,
          AppRoutes.login,
        );
      }

      return;
    }

    Navigator.pushReplacementNamed(
      context,
      AppRoutes.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.event,
                size: 90,
                color: Colors.white,
              ),

              const SizedBox(height: 24),

              const Text(
                'Eventra',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 30),

              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}