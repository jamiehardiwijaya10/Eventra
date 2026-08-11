import 'package:flutter/material.dart';

class BoothCategorySelector extends StatelessWidget {
  final List<String> categories;
  final List<String> selected;
  final ValueChanged<String> onToggle;

  const BoothCategorySelector({
    super.key,
    required this.categories,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: categories.map((category) {

        final isSelected = selected.contains(category);

        return FilterChip(
          label: Text(category),
          selected: isSelected,
          selectedColor: Colors.orange.shade100,
          checkmarkColor: Colors.orange,
          onSelected: (_) {
            onToggle(category);
          },
        );

      }).toList(),
    );
  }
}