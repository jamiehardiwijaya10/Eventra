import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'booth_stats.dart';

class BoothStatistics extends StatelessWidget {
  final List<BoothStatModel> stats;

  const BoothStatistics({
    super.key,
    required this.stats,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          "Booth Statistics",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 18),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: stats.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.25,
          ),
          itemBuilder: (_, index) {
            return BoothStatCard(
              stat: stats[index],
            );
          },
        ),
      ],
    );
  }
}