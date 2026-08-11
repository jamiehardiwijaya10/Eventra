import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_color.dart';

class BoothHeaderModel {
  final String image;
  final String name;
  final String category;
  final bool isOpen;

  const BoothHeaderModel({
    required this.image,
    required this.name,
    required this.category,
    required this.isOpen,
  });
}

class BoothHeaderCard extends StatelessWidget {
  final BoothHeaderModel booth;

  const BoothHeaderCard({
    super.key,
    required this.booth,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [

          CircleAvatar(
            radius: 42,
            backgroundImage: AssetImage(booth.image),
          ),

          const SizedBox(height: 18),

          Text(
            booth.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            booth.category,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: booth.isOpen
                  ? Colors.green.shade50
                  : Colors.red.shade50,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [

                Icon(
                  Icons.circle,
                  size: 10,
                  color: booth.isOpen
                      ? Colors.green
                      : Colors.red,
                ),

                const SizedBox(width: 8),

                Text(
                  booth.isOpen
                      ? "Open"
                      : "Closed",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: booth.isOpen
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}