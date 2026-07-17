import 'package:flutter/material.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../shared/widgets/custom_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [

            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [

                    const SizedBox(height: 20),

                    Image.asset(
                      "assets/images/event.png",
                      height: 60,
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: Image.asset(
                        "assets/images/Onboarding Pic.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(35),
                  ),
                ),

                child: Column(
                  children: [

                    const SizedBox(height: 20),

                    const Text(
                      "Explore Upcoming and\nNearby Events",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.title,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Discover exciting events around you and\nstay connected with your favorite activities.",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.subtitle,
                    ),

                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [

                        Icon(
                          Icons.circle,
                          color: Colors.white,
                          size: 10,
                        ),

                        SizedBox(width: 8),

                        Icon(
                          Icons.circle_outlined,
                          color: Colors.white,
                          size: 10,
                        ),

                        SizedBox(width: 8),

                        Icon(
                          Icons.circle_outlined,
                          color: Colors.white,
                          size: 10,
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [

                        TextButton(
                          onPressed: () {},
                          child: const Text("Skip"),
                        ),

                        SizedBox(
                          width: 120,
                          child: CustomButton(
                            text: "Next",
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}