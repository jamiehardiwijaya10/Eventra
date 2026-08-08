import 'package:flutter/material.dart';
import 'booth_category_selector.dart';
import 'datetime_picker_card.dart';
import 'number_input_card.dart';

class BoothConfigurationStep extends StatelessWidget {

  final TextEditingController maximumBoothController;
  final TextEditingController registrationFeeController;

  final DateTime? registrationDeadline;

  final VoidCallback onDeadlineTap;

  final List<String> selectedCategories;

  final ValueChanged<String> onCategoryToggle;

  const BoothConfigurationStep({
    super.key,
    required this.maximumBoothController,
    required this.registrationFeeController,
    required this.registrationDeadline,
    required this.onDeadlineTap,
    required this.selectedCategories,
    required this.onCategoryToggle,
  });

  static const categories = [
    "Food",
    "Beverage",
    "Fashion",
    "Craft",
    "Merchandise",
    "Game",
    "Art",
    "Services",
  ];

  String formatDate(DateTime? date) {

    if (date == null) return "Select Date";

    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Booth Configuration",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          "Configure booth registration for your event.",
          style: TextStyle(
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 28),

        NumberInputCard(
          title: "Maximum Booth",
          hint: "50",
          controller: maximumBoothController,
          icon: Icons.storefront,
        ),

        const SizedBox(height: 20),

        NumberInputCard(
          title: "Registration Fee",
          hint: "100000",
          controller: registrationFeeController,
          icon: Icons.payments_outlined,
        ),

        const SizedBox(height: 20),

        DateTimePickerCard(
          title: "Registration Deadline",
          value: formatDate(registrationDeadline),
          icon: Icons.event_available,
          onTap: onDeadlineTap,
        ),

        const SizedBox(height: 28),

        const Text(
          "Allowed Booth Categories",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 12),

        BoothCategorySelector(
          categories: categories,
          selected: selectedCategories,
          onToggle: onCategoryToggle,
        ),
      ],
    );
  }
}