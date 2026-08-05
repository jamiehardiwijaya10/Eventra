import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'history_card.dart';

class HistorySection extends StatelessWidget {

  final List<HistoryEvent> events;

  const HistorySection({
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
              "Event History",
              style: GoogleFonts.poppins(
                fontSize:18,
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

        const SizedBox(height:18),

        ...events.map(
              (e) => HistoryCard(
            event: e,
            onTap: () {},
          ),
        ),
      ],
    );
  }
}