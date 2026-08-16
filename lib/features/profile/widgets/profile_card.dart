import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_color.dart';

class ProfileCard extends StatelessWidget {
  final String image;
  final String name;
  final String email;
  final String phone;

  final String? companyName;
  final String? teamLeader;
  final String? officialWebsite;
  final String? brandName;

  final String? instagram;
  final String? facebook;
  final String? tiktok;
  final String? x;

  final bool isBoothOwner;
  final bool isEO;

  const ProfileCard({
    super.key,
    required this.image,
    required this.name,
    required this.email,
    required this.phone,
    this.companyName,
    this.teamLeader,
    this.officialWebsite,
    this.brandName,
    this.instagram,
    this.facebook,
    this.tiktok,
    this.x,
    this.isBoothOwner = false,
    this.isEO = false,
  });

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColor.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialRow(
    IconData icon,
    String label,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: AppColor.primary,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialMedia() {
    final socials = <String, String>{
      if (instagram != null && instagram!.isNotEmpty)
        "Instagram": instagram!,
      if (facebook != null && facebook!.isNotEmpty)
        "Facebook": facebook!,
      if (tiktok != null && tiktok!.isNotEmpty)
        "TikTok": tiktok!,
      if (x != null && x!.isNotEmpty)
        "X": x!,
    };

    if (socials.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.share_outlined,
                size: 20,
                color: AppColor.primary,
              ),
              const SizedBox(width: 10),
              Text(
                "Social Media",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ...socials.entries.map(
            (entry) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                "${entry.key}: ${entry.value}",
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasSocialMedia =
        (instagram != null && instagram!.trim().isNotEmpty) ||
        (facebook != null && facebook!.trim().isNotEmpty) ||
        (tiktok != null && tiktok!.trim().isNotEmpty) ||
        (x != null && x!.trim().isNotEmpty);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 28,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.grey.shade200,
            backgroundImage:
                image.trim().isNotEmpty
                    ? NetworkImage(image)
                    : null,
            child: image.trim().isEmpty
                ? Icon(
                    Icons.person_rounded,
                    size: 48,
                    color: Colors.grey.shade500,
                  )
                : null,
          ),

          const SizedBox(height: 18),

          Text(
            name.isEmpty ? '-' : name,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            email,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            phone.isEmpty ? '-' : phone,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 20),

          if (isEO) ...[
            if (companyName != null &&
                companyName!.trim().isNotEmpty)
              _buildInfoRow(
                Icons.business_outlined,
                "Company Name",
                companyName!,
              ),

            if (teamLeader != null &&
                teamLeader!.trim().isNotEmpty)
              _buildInfoRow(
                Icons.groups_outlined,
                "Team Leader",
                teamLeader!,
              ),
          ],

          if ((isEO || isBoothOwner) &&
              officialWebsite != null &&
              officialWebsite!.trim().isNotEmpty)
            _buildInfoRow(
              Icons.language_outlined,
              "Official Website",
              officialWebsite!,
            ),

            if ((isEO || isBoothOwner) &&
                (instagram != null && instagram!.isNotEmpty ||
                    facebook != null && facebook!.isNotEmpty ||
                    tiktok != null && tiktok!.isNotEmpty ||
                    x != null && x!.isNotEmpty)) ...[
              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Social Media",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              if (instagram != null && instagram!.isNotEmpty)
                _buildInfoRow(
                  Icons.camera_alt_outlined,
                  "Instagram",
                  instagram!,
                ),

              if (facebook != null && facebook!.isNotEmpty)
                _buildInfoRow(
                  Icons.facebook_outlined,
                  "Facebook",
                  facebook!,
                ),

              if (tiktok != null && tiktok!.isNotEmpty)
                _buildInfoRow(
                  Icons.music_note_outlined,
                  "TikTok",
                  tiktok!,
                ),

              if (x != null && x!.isNotEmpty)
                _buildInfoRow(
                  Icons.close,
                  "X",
                  x!,
                ),
            ],

          if ((isEO || isBoothOwner) && hasSocialMedia) ...[
          ],
        ],
      ),
    );
  }
}