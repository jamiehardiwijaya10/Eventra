import 'package:flutter/material.dart';

class EventTypeSelector extends StatelessWidget {
  final bool isIndoor;
  final ValueChanged<bool> onChanged;

  const EventTypeSelector({
    super.key,
    required this.isIndoor,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<bool>(
            value: false,
            groupValue: isIndoor,
            title: const Text("Outdoor"),
            onChanged: (value) => onChanged(false),
          ),
        ),
        Expanded(
          child: RadioListTile<bool>(
            value: true,
            groupValue: isIndoor,
            title: const Text("Indoor"),
            onChanged: (value) => onChanged(true),
          ),
        ),
      ],
    );
  }
}