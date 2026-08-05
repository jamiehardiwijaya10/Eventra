import 'package:flutter/material.dart';

class EventTopBar extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onFavorite;

  const EventTopBar({
    super.key,
    required this.onBack,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [

            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.black38,
              child: IconButton(
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),

            CircleAvatar(
              radius: 22,
              backgroundColor: Colors.black38,
              child: IconButton(
                onPressed: onFavorite,
                icon: const Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}