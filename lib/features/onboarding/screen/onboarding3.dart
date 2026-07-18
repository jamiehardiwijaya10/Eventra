import 'package:flutter/material.dart';
import '../../../core/theme/app_text_style.dart';
import '../../../core/theme/app_color.dart';
import '../../../app/routes.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

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
                        "assets/images/onboarding3.png",
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
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColor.primary,
                      AppColor.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(35),
                  ),
                ),

                child: Column(
                  children: [

                    const SizedBox(height: 20),

                    const Text(
                      "Enjoy Every Event\nExperience",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.title,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Stay updated with schedules, discover\nnew booths, and make every visit memorable.",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.subtitle,
                    ),

                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [

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

                        SizedBox(width: 8),

                        Icon(
                          Icons.circle,
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
                          child: const Text(
                            "Skip",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),

                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "Next",
                            style: TextStyle(
                              color: Colors.white,
                            ),
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