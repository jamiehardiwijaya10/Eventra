import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegistrationSectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const RegistrationSectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 18),

          Divider(
            color: Colors.grey.shade300,
            height: 1,
          ),
        ],
      ),
    );
  }
}