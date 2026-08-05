import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_color.dart';

class RegistrationStepIndicator extends StatelessWidget {
  final int currentStep;

  const RegistrationStepIndicator({
    super.key,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    const steps = [
      "Booth",
      "Contact",
      "Upload",
      "Review",
    ];

    return Row(
      children: List.generate(
        steps.length,
            (index) {
          final active = index <= currentStep;

          return Expanded(
            child: Column(
              children: [

                Row(
                  children: [

                    CircleAvatar(
                      radius: 15,
                      backgroundColor: active
                          ? AppColor.primary
                          : Colors.grey.shade300,
                      child: Icon(
                        active
                            ? Icons.check
                            : Icons.circle,
                        size: active ? 16 : 10,
                        color: Colors.white,
                      ),
                    ),

                    if (index != steps.length - 1)
                      Expanded(
                        child: Container(
                          height: 3,
                          color: active
                              ? AppColor.primary
                              : Colors.grey.shade300,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  steps[index],
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: active
                        ? AppColor.primary
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}