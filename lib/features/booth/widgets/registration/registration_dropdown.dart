import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationDropdown<T> extends StatelessWidget {
  final String label;
  final String hint;
  final bool requiredField;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const RegistrationDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.value,
    required this.items,
    required this.onChanged,
    this.requiredField = false,
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

          DropdownButtonFormField<T>(
            value: value,
            items: items,
            onChanged: onChanged,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),

            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
            ),

            decoration: InputDecoration(
              hintText: hint,

              hintStyle: GoogleFonts.poppins(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),

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