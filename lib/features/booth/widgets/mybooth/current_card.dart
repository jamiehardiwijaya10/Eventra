import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_color.dart';

class CurrentEventModel {
  final String eventName;
  final String boothNumber;
  final String date;
  final String location;
  final bool isActive;

  const CurrentEventModel({
    required this.eventName,
    required this.boothNumber,
    required this.date,
    required this.location,
    required this.isActive,
  });
}

class CurrentEventCard extends StatelessWidget {
  final CurrentEventModel event;

  final VoidCallback onViewEvent;
  final VoidCallback onViewMap;
  final VoidCallback onShowQR;

  const CurrentEventCard({
    super.key,
    required this.event,
    required this.onViewEvent,
    required this.onViewMap,
    required this.onShowQR,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [

              const Icon(
                Icons.event_available_rounded,
                color: Colors.white,
              ),

              const SizedBox(width: 8),

              Text(
                "Current Event",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.18),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  event.isActive ? "ACTIVE" : "ENDED",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            event.eventName,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: [

              const Icon(
                Icons.calendar_today_rounded,
                color: Colors.white70,
                size: 18,
              ),

              const SizedBox(width: 8),

              Text(
                event.date,
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
                Icons.location_on_outlined,
                color: Colors.white70,
                size: 18,
              ),

              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  event.location,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [

              const Icon(
                Icons.storefront_outlined,
                color: Colors.white70,
                size: 18,
              ),

              const SizedBox(width: 8),

              Text(
                event.boothNumber,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                ),
              ),
            ],
          ),

          const SizedBox(height: 22),

          Row(
            children: [

              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onViewEvent,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.white,
                    ),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.info_outline),
                  label: const Text("Details"),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onViewMap,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.white,
                    ),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.map_outlined),
                  label: const Text("Map"),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onShowQR,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColor.primary,
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.qr_code_2),
                  label: const Text("QR"),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}