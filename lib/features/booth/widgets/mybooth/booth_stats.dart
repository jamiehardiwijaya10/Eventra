import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BoothStatModel {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const BoothStatModel({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });
}

class BoothStatCard extends StatelessWidget {
  final BoothStatModel stat;

  const BoothStatCard({
    super.key,
    required this.stat,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: stat.color.withOpacity(.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              stat.icon,
              color: stat.color,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            stat.value,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            stat.title,
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}