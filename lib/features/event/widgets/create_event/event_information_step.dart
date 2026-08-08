import 'dart:io';
import 'package:flutter/material.dart';

class EventInformationStep extends StatelessWidget {
  final TextEditingController eventNameController;
  final TextEditingController descriptionController;

  final String? selectedCategory;

  final ValueChanged<String?> onCategoryChanged;

  final File? bannerImage;
  final File? logoImage;

  final VoidCallback onBannerTap;
  final VoidCallback onLogoTap;

  const EventInformationStep({
    super.key,
    required this.eventNameController,
    required this.descriptionController,
    required this.selectedCategory,
    required this.onCategoryChanged,
    required this.bannerImage,
    required this.logoImage,
    required this.onBannerTap,
    required this.onLogoTap,
  });

  static const categories = [
    "Food Festival",
    "Expo",
    "Bazaar",
    "Exhibition",
    "Concert",
    "Seminar",
    "Workshop",
    "Sports",
    "Community",
    "Others",
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Event Information",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          "Complete the basic information about your event.",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 30),

        const Text(
          "Event Name",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: eventNameController,
          decoration: InputDecoration(
            hintText: "Food Festival Bandung",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),

        const SizedBox(height: 22),

        const Text(
          "Event Category",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        DropdownButtonFormField<String>(
          value: selectedCategory,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          items: categories
              .map(
                (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
              .toList(),
          onChanged: onCategoryChanged,
        ),

        const SizedBox(height: 22),

        const Text(
          "Description",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        TextField(
          controller: descriptionController,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: "Describe your event...",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),

        const SizedBox(height: 30),

        Row(
          children: [

            Expanded(
              child: _UploadCard(
                title: "Event Banner",
                image: bannerImage,
                onTap: onBannerTap,
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: _UploadCard(
                title: "Event Logo",
                image: logoImage,
                onTap: onLogoTap,
              ),
            ),

          ],
        ),

      ],
    );
  }
}

class _UploadCard extends StatelessWidget {

  final String title;
  final File? image;
  final VoidCallback onTap;

  const _UploadCard({
    required this.title,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: image == null
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Icon(
              Icons.cloud_upload_outlined,
              size: 42,
              color: Colors.orange,
            ),

            const SizedBox(height: 12),

            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            const Text(
              "Tap to upload",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),

          ],
        ) : ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            image!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}