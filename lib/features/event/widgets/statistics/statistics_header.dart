import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class StatisticsHeader extends StatelessWidget {
  final String selectedEvent;
  final List<String> events;
  final ValueChanged<String?> onEventChanged;

  const StatisticsHeader({
    super.key,
    required this.selectedEvent,
    required this.events,
    required this.onEventChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Statistics",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 6),

        const Text(
          "Monitor your event performance and activity.",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          "Select Event",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 10),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedEvent,
              isExpanded: true,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
              ),
              dropdownColor: Colors.white,
              items: events.map((event) {
                return DropdownMenuItem<String>(
                  value: event,
                  child: Row(
                    children: [
                      Icon(
                        Icons.event_outlined,
                        size: 20,
                        color: AppColor.primary,
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: Text(
                          event,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onEventChanged,
            ),
          ),
        ),
      ],
    );
  }
}