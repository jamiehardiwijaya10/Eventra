import 'package:flutter/material.dart';
import '../../../app/routes.dart';
import '../../../shared/widgets/custom_button.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event, size: 90, color: Colors.white),
              
              CustomButton(text: 'Nega', onPressed: () {
                Navigator.pushNamed(context, AppRoutes.login);
              }),

              SizedBox(height: 24),

              Text(
                'Eventra',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
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
