import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'group_card.dart';

class GroupSection extends StatelessWidget {
  final GroupChat currentGroup;
  final List<GroupChat> otherGroups;

  const GroupSection({
    super.key,
    required this.currentGroup,
    required this.otherGroups,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          "Current Event",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          "Stay connected with people at your current event.",
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 18),

        GroupCard(
          group: currentGroup,
          onTap: () {},
        ),

        const SizedBox(height: 28),

        Row(
          children: [

            Text(
              "Other Groups",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            TextButton(
              onPressed: () {},
              child: const Text("See All"),
            ),
          ],
        ),

        const SizedBox(height: 16),

        ...otherGroups.map(
              (group) => GroupCard(
            group: group,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}