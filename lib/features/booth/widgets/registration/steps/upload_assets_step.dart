import 'dart:io';
import 'package:flutter/material.dart';
import '../section_titles.dart';
import '../upload_card.dart';

class UploadAssetsStep extends StatelessWidget {
  final File? logoImage;
  final File? bannerImage;
  final File? boothImage;

  final VoidCallback onLogoTap;
  final VoidCallback onBannerTap;
  final VoidCallback onBoothTap;

  const UploadAssetsStep({
    super.key,
    required this.logoImage,
    required this.bannerImage,
    required this.boothImage,
    required this.onLogoTap,
    required this.onBannerTap,
    required this.onBoothTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const RegistrationSectionTitle(
          title: "Upload Assets",
          subtitle:
          "Upload your booth logo, banner, and booth photo to help visitors recognize your business.",
        ),

        UploadCard(
          title: "Booth Logo",
          subtitle:
          "Square image (PNG/JPG). Recommended 512 × 512 px.",
          image: logoImage,
          onTap: onLogoTap,
          icon: Icons.storefront_outlined,
        ),

        UploadCard(
          title: "Booth Banner",
          subtitle:
          "Landscape image for your booth header.",
          image: bannerImage,
          onTap: onBannerTap,
          icon: Icons.image_outlined,
        ),

        UploadCard(
          title: "Booth Photo",
          subtitle:
          "Show visitors what your booth looks like.",
          image: boothImage,
          onTap: onBoothTap,
          icon: Icons.photo_camera_outlined,
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}