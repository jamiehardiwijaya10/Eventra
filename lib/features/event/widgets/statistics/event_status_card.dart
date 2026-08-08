import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class EventStatusCard extends StatelessWidget {
  final int upcoming;
  final int ongoing;
  final int finished;

  const EventStatusCard({
    super.key,
    required this.upcoming,
    required this.ongoing,
    required this.finished,
  });

  @override
  Widget build(BuildContext context) {
    final total = upcoming + ongoing + finished;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Event Status",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Overview of your event status.",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: _StatusItem(
                  title: "Upcoming",
                  value: upcoming,
                  icon: Icons.event_outlined,
                  iconColor: Colors.blue,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _StatusItem(
                  title: "Ongoing",
                  value: ongoing,
                  icon: Icons.play_circle_outline,
                  iconColor: AppColor.primary,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _StatusItem(
                  title: "Finished",
                  value: finished,
                  icon: Icons.check_circle_outline,
                  iconColor: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.event_note_outlined,
                  size: 20,
                  color: Colors.grey,
                ),

                const SizedBox(width: 10),

                const Expanded(
                  child: Text(
                    "Total Events",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ),

                Text(
                  "$total",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final String title;
  final int value;
  final IconData icon;
  final Color iconColor;

  const _StatusItem({
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: iconColor,
            size: 24,
          ),

          const SizedBox(height: 8),

          Text(
            "$value",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}