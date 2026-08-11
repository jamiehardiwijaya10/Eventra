import 'package:flutter/material.dart';

class MyEventHeader extends StatelessWidget {
  const MyEventHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [

        Text(
          "My Events",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(height: 8),

        Text(
          "Manage and monitor all events you organize.",
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey,
            height: 1.4,
          ),
        ),

      ],
    );
  }
}