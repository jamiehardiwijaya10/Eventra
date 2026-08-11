import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_color.dart';

class OrganizerCard extends StatelessWidget {
  final String image;
  final String name;
  final String role;
  final VoidCallback? onChat;
  final VoidCallback? onCall;

  const OrganizerCard({
    super.key,
    required this.image,
    required this.name,
    required this.role,
    this.onChat,
    this.onCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage(image),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  role,
                  style: GoogleFonts.poppins(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(
              color: AppColor.primary.withOpacity(0.80),
              borderRadius:
              BorderRadius.circular(14),
            ),
            child: IconButton(
              onPressed: onChat,
              icon: const Icon(
                Icons.chat_bubble_outline,
                color: AppColor.white,
              ),
            ),
          ),

          const SizedBox(width: 10),

          Container(
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius:
              BorderRadius.circular(14),
            ),
            child: IconButton(
              onPressed: onCall,
              icon: const Icon(
                Icons.call_outlined,
                color: Colors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }
}