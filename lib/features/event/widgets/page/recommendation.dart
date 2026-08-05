import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'event_horizontal_card.dart';

class RecommendedSection extends StatelessWidget {
  final List<RecommendedEvent> events;

  const RecommendedSection({
    super.key,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Recommended For You",
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

        const SizedBox(height: 18),

        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: events.length,
            itemBuilder: (_, index) {
              return EventHorizontalCard(
                event: events[index],
                onTap: () {},
              );
            },
          ),
        ),
      ],
    );
  }
}