import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_color.dart';
import '../../../app/routes.dart';

class FeaturedEventCard extends StatelessWidget {
  final String eventId;
  final String image;
  final String title;
  final String startDate;
  final String endDate;
  final String location;


  const FeaturedEventCard({
    super.key,
    required this.eventId,
    required this.image,
    required this.title,
    required this.startDate,
    required this.endDate,
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
        boxShadow: const [
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
              child: SizedBox(
                height: 185,
                width: double.infinity,
                child: image.isEmpty
                    ? Container(
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 40,
                        ),
                      )
                    : Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 40,
                            ),
                          );
                        },
                      ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
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
                Expanded(
                  child: Text(
                    "$startDate - $endDate",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                    ),
                  ),
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
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Image.asset(
                  "assets/images/Member A.png",
                  height: 22,
                  fit: BoxFit.contain,
                ),

                const SizedBox(width: 5),

                Expanded(
                  child: Text(
                    "Members Joined",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.event,
                      arguments: eventId,
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text("JOIN NOW"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}