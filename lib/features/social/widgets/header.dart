import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendsChatHeader extends StatelessWidget {
  const FriendsChatHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          "Friends & Chat",
          style: GoogleFonts.poppins(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          "Stay connected with your event friends and communities.",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey.shade600,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}