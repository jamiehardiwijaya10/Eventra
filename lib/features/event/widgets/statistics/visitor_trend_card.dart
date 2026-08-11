import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class VisitorTrendCard extends StatelessWidget {
  final List<VisitorData> data;

  const VisitorTrendCard({
    super.key,
    required this.data,
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
            "Visitor Trend",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Number of visitors during the event.",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((item) {
                final maxValue = data
                    .map((e) => e.visitors)
                    .reduce((a, b) => a > b ? a : b);

                final height = maxValue == 0
                    ? 0.0
                    : (item.visitors / maxValue) * 130;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
                    child: Column(
                      mainAxisAlignment:
                      MainAxisAlignment.end,
                      children: [
                        Text(
                          item.visitors.toString(),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Container(
                          height: height,
                          decoration: BoxDecoration(
                            color: AppColor.primary,
                            borderRadius:
                            const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          item.label,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class VisitorData {
  final String label;
  final int visitors;

  const VisitorData({
    required this.label,
    required this.visitors,
  });
}