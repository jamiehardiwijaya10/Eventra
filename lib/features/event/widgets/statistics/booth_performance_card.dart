import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class BoothPerformanceCard extends StatelessWidget {
  final List<BoothPerformanceData> booths;

  const BoothPerformanceCard({
    super.key,
    required this.booths,
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
            "Booth Performance",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            "Most active booths during the event.",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 20),

          if (booths.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "No booth data available.",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            )
          else
            ...booths.asMap().entries.map(
                  (entry) {
                final index = entry.key;
                final booth = entry.value;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == booths.length - 1
                        ? 0
                        : 18,
                  ),
                  child: _BoothPerformanceItem(
                    rank: index + 1,
                    booth: booth,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _BoothPerformanceItem extends StatelessWidget {
  final int rank;
  final BoothPerformanceData booth;

  const _BoothPerformanceItem({
    required this.rank,
    required this.booth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: rank == 1
                ? AppColor.primary.withOpacity(0.12)
                : Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          child: Text(
            "$rank",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: rank == 1
                  ? AppColor.primary
                  : Colors.black87,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                booth.boothName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              Text(
                booth.category,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 12),

        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "${booth.activityCount}",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),

            const Text(
              "activity",
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BoothPerformanceData {
  final String boothName;
  final String category;
  final int activityCount;

  const BoothPerformanceData({
    required this.boothName,
    required this.category,
    required this.activityCount,
  });
}