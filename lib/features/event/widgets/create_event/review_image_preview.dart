import 'dart:typed_data';
import 'package:flutter/material.dart';

class ReviewImagePreview extends StatelessWidget {
  final String title;
  final Uint8List? image;

  const ReviewImagePreview({
    super.key,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 8),

        Container(
          width: double.infinity,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
          ),
          child: image == null
              ? const Center(
                  child: Text(
                    "No image",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.memory(
                    image!,
                    fit: BoxFit.cover,
                  ),
                ),
        ),
      ],
    );
  }
}