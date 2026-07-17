import 'package:flutter/material.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../core/theme/app_text_style.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              const SizedBox(height: 50),

              /// Character
              Center(
                child: Image.asset(
                  "assets/images/miyabi.png",
                  height: 180,
                ),
              ),

              const SizedBox(height: 30),

              const Center(
                child: Text(
                  "What Are You?",
                  style: AppTextStyle.title,
                ),
              ),

              const SizedBox(height: 50),

              CustomButton(
                text: "Event Customer",
                onPressed: () {
                  debugPrint("Customer");
                },
              ),

              const SizedBox(height: 20),

              CustomButton(
                text: "Event Booth",
                onPressed: () {
                  debugPrint("Booth");
                },
              ),

              const SizedBox(height: 20),

              CustomButton(
                text: "Event Organizer",
                onPressed: () {
                  debugPrint("Organizer");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}