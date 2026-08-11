import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'review_image_preview.dart';
import 'review_section_card.dart';

class ReviewPublishStep extends StatelessWidget {
  final String eventName;
  final String category;
  final String description;

  final String venue;
  final String address;

  final String startDate;
  final String endDate;

  final String openingTime;
  final String closingTime;

  final String maximumBooth;
  final String registrationFee;

  final List<String> categories;

  final Uint8List? banner;
  final Uint8List? logo;
  final Uint8List? floorplan;

  final bool agree;
  final ValueChanged<bool?> onAgreeChanged;

  const ReviewPublishStep({
    super.key,
    required this.eventName,
    required this.category,
    required this.description,
    required this.venue,
    required this.address,
    required this.startDate,
    required this.endDate,
    required this.openingTime,
    required this.closingTime,
    required this.maximumBooth,
    required this.registrationFee,
    required this.categories,
    required this.banner,
    required this.logo,
    required this.floorplan,
    required this.agree,
    required this.onAgreeChanged,
  });

  Widget reviewTile(
      String title,
      String value,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? "-" : value,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Review & Publish",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          "Please review all information before publishing your event.",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 24),

        ReviewSectionCard(
          title: "Event Information",
          children: [
            reviewTile("Event Name", eventName),
            reviewTile("Category", category),
            reviewTile("Description", description),
          ],
        ),

        const SizedBox(height: 18),

        ReviewSectionCard(
          title: "Venue & Schedule",
          children: [
            reviewTile("Venue", venue),
            reviewTile("Address", address),
            reviewTile("Start Date", startDate),
            reviewTile("End Date", endDate),
            reviewTile("Opening", openingTime),
            reviewTile("Closing", closingTime),
          ],
        ),

        const SizedBox(height: 18),

        ReviewSectionCard(
          title: "Booth Configuration",
          children: [
            reviewTile(
              "Maximum Booth",
              maximumBooth,
            ),
            reviewTile(
              "Registration Fee",
              registrationFee,
            ),
            reviewTile(
              "Categories",
              categories.isEmpty
                  ? "-"
                  : categories.join(", "),
            ),
          ],
        ),

        const SizedBox(height: 18),

        ReviewSectionCard(
          title: "Uploaded Assets",
          children: [
            ReviewImagePreview(
              title: "Banner",
              image: banner,
            ),

            const SizedBox(height: 12),

            ReviewImagePreview(
              title: "Logo",
              image: logo,
            ),

            const SizedBox(height: 12),

            ReviewImagePreview(
              title: "Floorplan",
              image: floorplan,
            ),
          ],
        ),

        const SizedBox(height: 18),

        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          value: agree,
          activeColor: Colors.orange,
          onChanged: onAgreeChanged,
          title: const Text(
            "I confirm that all information provided is correct.",
          ),
        ),

        const SizedBox(height: 30),
      ],
    );
  }
}