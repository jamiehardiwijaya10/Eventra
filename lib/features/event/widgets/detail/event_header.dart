import 'package:flutter/material.dart';

class EventHeaderImage extends StatelessWidget {
  final String image;

  const EventHeaderImage({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .45,
      width: double.infinity,
      child: Image.asset(
        image,
        fit: BoxFit.cover,
      ),
    );
  }
}