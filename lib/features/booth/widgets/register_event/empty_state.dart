import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyEventState extends StatelessWidget {
  final String title;
  final String subtitle;

  const EmptyEventState({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            Icon(
              Icons.event_busy_outlined,
              size: 90,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 20),

            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}