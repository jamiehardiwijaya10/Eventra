import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_color.dart';

class SuggestedFriendModel {
  final String image;
  final String name;
  final String subtitle;

  const SuggestedFriendModel({
    required this.image,
    required this.name,
    required this.subtitle,
  });
}

class SuggestedFriendCard extends StatelessWidget {
  final SuggestedFriendModel friend;
  final VoidCallback onAdd;

  const SuggestedFriendCard({
    super.key,
    required this.friend,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165,
      margin: const EdgeInsets.only(right: 14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            CircleAvatar(
              radius: 34,
              backgroundImage: AssetImage(friend.image),
            ),

            const SizedBox(height: 14),

            Text(
              friend.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              friend.subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(
                  Icons.person_add_alt_1,
                  size: 16,
                ),
                label: const Text("Add"),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColor.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}