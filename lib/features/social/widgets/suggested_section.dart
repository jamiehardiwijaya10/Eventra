import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'suggested_card.dart';

class SuggestedFriendSection extends StatelessWidget {
  final List<SuggestedFriendModel> friends;

  const SuggestedFriendSection({
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
              "People You May Know",
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
        if(friends.isEmpty)
          Text(
            "No suggestions available",
            style: GoogleFonts.poppins(
              color: Colors.grey,
            ),
          )
        else
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: friends.length,
              itemBuilder: (context,index){
                return SuggestedFriendCard(
                  friend: friends[index],
                  onAdd: () {},
                );
              },
            ),
          ),
      ],
    );
  }
}