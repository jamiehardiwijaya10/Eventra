import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_color.dart';

class EventFilterModel {
  final String title;

  const EventFilterModel({
    required this.title,
  });
}

class EventFilterChip extends StatelessWidget {
  final List<EventFilterModel> filters;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const EventFilterChip({
    super.key,
    required this.filters,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, index) {
          final isSelected = index == selectedIndex;

          return InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () => onSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColor.primary
                    : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isSelected
                      ? AppColor.primary
                      : Colors.grey.shade300,
                ),
              ),
              child: Center(
                child: Text(
                  filters[index].title,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : Colors.black87,
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