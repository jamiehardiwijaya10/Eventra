import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/custom_app_bar.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/constant/app_strings.dart';
import '../../../app/routes.dart';

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

            const Text("Welcome Back", style: AppTextStyle.title),

            const SizedBox(height: 10),

            const Text(AppStrings.login, style: AppTextStyle.subtitle),

            const SizedBox(height: 40),

            CustomTextField(
              hintText: AppStrings.email,
              prefixIcon: Icons.email,
              controller: emailController,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              hintText: AppStrings.password,
              prefixIcon: Icons.lock,
              obscureText: true,
              controller: passwordController,
            ),

            const SizedBox(height: 30),

            CustomButton(
              text: AppStrings.login,
              onPressed: () {
                debugPrint("Users Login");
              },
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.register);
                  },
                  child: const Text(AppStrings.register),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
