import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_color.dart';

class CurrentEventCard extends StatelessWidget {
  final String image;
  final String title;
  final String location;
  final String date;
  final int joined;

  final VoidCallback onOpenEvent;
  final VoidCallback onOpenMap;

  const CurrentEventCard({
    super.key,
    required this.image,
    required this.title,
    required this.location,
    required this.date,
    required this.joined,
    required this.onOpenEvent,
    required this.onOpenMap,
  });

  String formatMembers(int value) {
    if (value >= 1000000) {
      return "${(value / 1000000).toStringAsFixed(1)}M";
    } else if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(1)}K";
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(24),
            ),
            child: Image.asset(
              image,
              height: 170,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "CURRENT EVENT",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                Text(
                  title,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [

                    const Icon(
                      Icons.location_on_outlined,
                      color: Colors.white70,
                      size: 18,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      location,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [

                    const Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.white70,
                      size: 17,
                    ),

                    const SizedBox(width: 6),

                    Text(
                      date,
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                Text(
                  "${formatMembers(joined)} people joined",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  children: [

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColor.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        onPressed: onOpenEvent,
                        child: const Text("Open Event"),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(
                            color: Colors.white,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: onOpenMap,
                        child: const Text("Booth Map"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}