import 'package:flutter/material.dart';

class EventHeaderImage extends StatelessWidget {
  final String image;

  const EventHeaderImage({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      image,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: Colors.grey.shade200,
          child: const Center(
            child: Icon(
              Icons.broken_image,
              size: 50,
            ),
          ),
        );
      },
    );
  }
}