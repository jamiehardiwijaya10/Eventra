import 'package:flutter/material.dart';
// import '../features/splash/screen/splash_screen.dart';
import 'package:eventra/features/auth/screens/login_screen.dart';

class EventraApp extends StatelessWidget {
  const EventraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eventra',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}