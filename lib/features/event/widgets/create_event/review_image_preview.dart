import 'dart:io';

import 'package:flutter/material.dart';

class ReviewImagePreview extends StatelessWidget {

  final String title;
  final File? image;

  const ReviewImagePreview({
    super.key,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [

        SizedBox(
          width: 110,
          child: Text(title),
        ),

        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: image == null
              ? Container(
            width: 80,
            height: 80,
            color: Colors.grey.shade200,
            child: const Icon(Icons.image),
          )
              : Image.file(
            image!,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),

      ],
    );
  }
}