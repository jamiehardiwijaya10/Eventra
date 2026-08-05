import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'friend_card.dart';

class FriendSection extends StatelessWidget {
  final List<FriendModel> friends;

  const FriendSection({
    super.key,
    required this.friends,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "Friends",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(width:8),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal:10,
                vertical:4,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                friends.length.toString(),
                style: GoogleFonts.poppins(
                  fontSize:12,
                  fontWeight:FontWeight.w600,
                ),
              ),
            ),

            const Spacer(),

            TextButton(
              onPressed:(){},
              child: const Text("See All"),
            ),
          ],
        ),
        const SizedBox(height:6),
        Text(
          "People you've connected with through events.",
          style: GoogleFonts.poppins(
            fontSize:13,
            color:Colors.grey,
          ),
        ),
        const SizedBox(height:20),
        ...friends.map(
              (friend)=>FriendCard(
            friend:friend,
            onTap:(){},
          ),
        ),
      ],
    );
  }
}