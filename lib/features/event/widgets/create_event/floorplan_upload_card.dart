import 'package:flutter/material.dart';
import 'dart:typed_data';

class FloorplanUploadCard extends StatelessWidget {
  final Uint8List? image;
  final VoidCallback onTap;

  const FloorplanUploadCard({
    super.key,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: image == null
            ? const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.upload_file,
              color: Colors.orange,
              size: 42,
            ),
            SizedBox(height: 12),
            Text(
              "Upload Floorplan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              "Tap to upload venue layout",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.memory(
            image!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          )
        ),
      ),
    );
  }
}