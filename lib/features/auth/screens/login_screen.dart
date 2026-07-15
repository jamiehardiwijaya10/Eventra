import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_app_bar.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Login"),
      backgroundColor: Colors.orange,
      body: Padding(
        padding: EdgeInsetsGeometry.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            
            const Text(
              "Welcome Back",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Login",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 40),

            CustomTextField(
              hintText: "Email",
              prefixIcon: Icons.email,
              controller: emailController,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              hintText: "Password",
              prefixIcon: Icons.lock,
              obscureText: true,
              controller: passwordController,
            ),

            const SizedBox(height: 30),

            CustomButton(
              text: "Login",
              onPressed: () {
                debugPrint("Users Login");
              },
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(onPressed: () {}, child: const Text("Register")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
