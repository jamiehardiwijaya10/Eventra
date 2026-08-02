import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_color.dart';

class AttendeesSection extends StatelessWidget {
  final int totalMembers;
  final List<String> avatarImages;
  final VoidCallback? onViewAll;

  const AttendeesSection({
    super.key,
    required this.totalMembers,
    required this.avatarImages,
    this.onViewAll,
  });

  String formatMembers(int value) {
    if (value >= 1000000) {
      return "${(value / 1000000).toStringAsFixed(1)}M+";
    } else if (value >= 1000) {
      return "${(value / 1000).toStringAsFixed(1)}K+";
    }
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    final displayCount =
    avatarImages.length > 3 ? 3 : avatarImages.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "People Joining",
              style: GoogleFonts.poppins(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),

            const Spacer(),

            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: onViewAll,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 4,
                ),
                child: Row(
                  children: [
                    Text(
                      "See All",
                      style: GoogleFonts.poppins(
                        color: AppColor.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(width: 4),

                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: AppColor.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: displayCount * 22 + 40,
                height: 36,
                child: Stack(
                  children: [
                    for (int i = 0; i < displayCount; i++)
                      Positioned(
                        left: i * 22,
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 14,
                            backgroundImage:
                            AssetImage(avatarImages[i]),
                          ),
                        ),
                      ),

                    if (avatarImages.length > 3)
                      Positioned(
                        left: (displayCount * 22).toDouble(),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColor.primary,
                          child: Text(
                            "+${avatarImages.length - 3}",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${formatMembers(totalMembers)} people joined",
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Meet other attendees before the event starts.",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}