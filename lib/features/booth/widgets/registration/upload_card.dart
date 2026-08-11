import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Uint8List? image;
  final VoidCallback onTap;
  final IconData icon;

  const UploadCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.image,
    this.icon = Icons.cloud_upload_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: image == null
            ? Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 28,
            horizontal: 20,
          ),
          child: Column(
            children: [

              Icon(
                icon,
                size: 42,
                color: Colors.orange,
              ),

              const SizedBox(height: 14),

              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),

              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Choose Image",
                  style: GoogleFonts.poppins(
                    color: Colors.orange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [

             Image.memory(
              image!,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

              Positioned(
                right: 12,
                top: 12,
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white,
                      size: 18,
                    ),
                    onPressed: onTap,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}