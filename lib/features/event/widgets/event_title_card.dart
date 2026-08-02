import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_color.dart';

class EventTitleCard extends StatelessWidget {
  final String title;
  final String location;
  final String date;
  final String price;

  final double rating;
  final int joined;
  final int ticketsLeft;

  const EventTitleCard({
    super.key,
    required this.title,
    required this.location,
    required this.date,
    required this.price,
    required this.rating,
    required this.joined,
    required this.ticketsLeft,
  });

  String formatNumber(int value) {
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
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [

              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: Colors.grey,
              ),

              const SizedBox(width: 6),

              Expanded(
                child: Text(
                  location,
                  style: GoogleFonts.poppins(
                    color: Colors.grey.shade700,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: AppColor.primary.withOpacity(.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  price,
                  style: GoogleFonts.poppins(
                    color: AppColor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [

              const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: Colors.grey,
              ),

              const SizedBox(width: 6),

              Text(
                date,
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Divider(color: Colors.grey.shade200),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              _StatisticItem(
                icon: Icons.people_outline,
                title: "${formatNumber(joined)} Joined",
              ),

              _StatisticItem(
                icon: Icons.star,
                title: rating.toString(),
                color: Colors.amber,
              ),

              _StatisticItem(
                icon: Icons.confirmation_number_outlined,
                title: "$ticketsLeft Left",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatisticItem extends StatelessWidget {

  final IconData icon;
  final String title;
  final Color color;

  const _StatisticItem({
    required this.icon,
    required this.title,
    this.color = AppColor.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Icon(
          icon,
          size: 18,
          color: color,
        ),

        const SizedBox(width: 6),

        Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}