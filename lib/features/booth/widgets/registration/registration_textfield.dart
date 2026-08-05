import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationTextField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int maxLines;
  final bool requiredField;
  final Widget? suffixIcon;

  const RegistrationTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.requiredField = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              children: [
                TextSpan(text: label),

                if (requiredField)
                  const TextSpan(
                    text: " *",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: GoogleFonts.poppins(
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.poppins(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),

              suffixIcon: suffixIcon,

              filled: true,
              fillColor: Colors.white,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: Colors.grey.shade300,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: const BorderSide(
                  color: Colors.orange,
                  width: 1.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}