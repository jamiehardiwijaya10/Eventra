import 'package:flutter/material.dart';

class BoothStatusChip extends StatelessWidget {
  final String label;
  final bool isOpen;

  const BoothStatusChip({
    super.key,
    required this.label,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isOpen ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}