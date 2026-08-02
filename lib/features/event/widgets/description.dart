import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_color.dart';

class DescriptionSection extends StatefulWidget {
  final String description;

  const DescriptionSection({
    super.key,
    required this.description,
  });

  @override
  State<DescriptionSection> createState() =>
      _DescriptionSectionState();
}

class _DescriptionSectionState
    extends State<DescriptionSection> {

  bool expanded = false;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          "Description",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        AnimatedCrossFade(
          firstChild: Text(
            widget.description,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.7,
              color: Colors.grey.shade700,
            ),
          ),
          secondChild: Text(
            widget.description,
            style: GoogleFonts.poppins(
              fontSize: 14,
              height: 1.7,
              color: Colors.grey.shade700,
            ),
          ),
          crossFadeState: expanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 250),
        ),

        const SizedBox(height: 8),

        GestureDetector(
          onTap: () {
            setState(() {
              expanded = !expanded;
            });
          },
          child: Text(
            expanded ? "Show Less" : "Read More",
            style: GoogleFonts.poppins(
              color: AppColor.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}