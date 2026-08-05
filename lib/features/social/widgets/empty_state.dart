import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyState extends StatelessWidget {

  final IconData icon;
  final String title;
  final String subtitle;
  final String buttonText;

  final VoidCallback onPressed;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical:60),

      child: Column(

        children: [

          Icon(
            icon,
            size:80,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height:18),

          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize:20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height:8),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height:24),

          FilledButton(
            onPressed: onPressed,
            child: Text(buttonText),
          ),
        ],
      ),
    );
  }
}