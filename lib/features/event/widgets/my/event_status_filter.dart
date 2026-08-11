import 'package:flutter/material.dart';

class EventStatusFilter extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onSelected;

  const EventStatusFilter({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const List<String> status = [
    "All",
    "Ongoing",
    "Upcoming",
    "Finished",
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: status.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = status[index];
          final isSelected = item == selected;

          return InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => onSelected(item),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFFFF751F)
                    : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFF751F)
                      : Colors.grey.shade300,
                ),
              ),
              child: Center(
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                    isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}