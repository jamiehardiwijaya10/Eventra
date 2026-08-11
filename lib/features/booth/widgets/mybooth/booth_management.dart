import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'management_item.dart';

class BoothManagementGrid extends StatelessWidget {
  final List<BoothManagementModel> items;

  const BoothManagementGrid({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          "Management",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 18),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (_, index) {
            return BoothManagementItem(
              item: items[index],
            );
          },
        ),
      ],
    );
  }
}