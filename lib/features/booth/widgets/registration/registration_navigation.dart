import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_color.dart';

class RegistrationNavigation extends StatelessWidget {
  final int currentStep;
  final int totalStep;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const RegistrationNavigation({
    super.key,
    required this.currentStep,
    required this.totalStep,
    required this.onNext,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLastStep = currentStep == totalStep - 1;

    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        16,
        20,
        20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [

            if (currentStep != 0)
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: onBack,
                    icon: const Icon(Icons.arrow_back),
                    label: Text(
                      "Back",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColor.primary,
                      side: const BorderSide(
                        color: AppColor.primary,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),

            if (currentStep != 0)
              const SizedBox(width: 14),

            Expanded(
              flex: 2,
              child: SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: onNext,

                  icon: Icon(
                    isLastStep
                        ? Icons.check_circle_outline
                        : Icons.arrow_forward,
                    color: Colors.white,
                  ),

                  label: Text(
                    isLastStep
                        ? "Submit Registration"
                        : "Next",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}