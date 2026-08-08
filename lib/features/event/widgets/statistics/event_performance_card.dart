import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class EventPerformanceCard extends StatelessWidget {
  final List<EventPerformanceData> events;

  const EventPerformanceCard({
    super.key,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
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
            "Event Performance",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Compare visitor numbers across your events.",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),

          ...events.asMap().entries.map(
                (entry) {
              final index = entry.key;
              final event = entry.value;

              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == events.length - 1 ? 0 : 18,
                ),
                child: _EventPerformanceItem(
                  event: event,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _EventPerformanceItem extends StatelessWidget {
  final EventPerformanceData event;

  const _EventPerformanceItem({
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                event.eventName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(width: 12),

            Text(
              "${event.visitors} visitors",
              style: TextStyle(
                fontSize: 12,
                color: AppColor.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: event.progress,
            minHeight: 9,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              AppColor.primary,
            ),
          ),
        ),
      ],
    );
  }
}

class EventPerformanceData {
  final String eventName;
  final int visitors;
  final double progress;

  const EventPerformanceData({
    required this.eventName,
    required this.visitors,
    required this.progress,
  });
}