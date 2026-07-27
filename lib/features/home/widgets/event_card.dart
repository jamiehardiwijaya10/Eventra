import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_color.dart';

class FeaturedEventCard extends StatelessWidget {
  final String image;
  final String title;
  final String date;
  final String location;

  const FeaturedEventCard({
    super.key,
    required this.image,
    required this.title,
    required this.date,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 370,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),

      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                image,
                height: 185,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                const Icon(
                  Icons.calendar_month,
                  size: 18,
                  color: AppColor.primary,
                ),

                const SizedBox(width: 8),

                Text(
                  date,
                  style: GoogleFonts.poppins(fontSize: 12),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 18,
                  color: AppColor.primary,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    location,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 12),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [

                Image.asset(
                  "assets/images/Member A.png",
                  fit: BoxFit.contain,
                ),

                const SizedBox(width: 5),

                Text(
                    "Members Joined",
                    style: GoogleFonts.poppins(fontSize: 10),
                ),

                const SizedBox(width: 8),

                TextButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),

                  child: const Text("JOIN NOW"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

// body: Stack(
// children: [
// Column(
// children: [
// Container(
// height: 320,
// decoration: const BoxDecoration(
// gradient: LinearGradient(
// begin: Alignment.topCenter,
// end: Alignment.bottomCenter,
// colors: [
// AppColor.primary,
// AppColor.secondary,
// ],
// ),
// ),
// ),
//
// Container(
// height: 900,
// color: Colors.white.withOpacity(0.9),
// ),
//
// ],
// ),