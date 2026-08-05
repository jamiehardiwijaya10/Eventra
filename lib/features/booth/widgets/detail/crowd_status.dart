import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class CrowdStatusCard extends StatelessWidget {
  final String title;
  final String description;
  final String lastUpdated;
  final String status;
  final VoidCallback onTapHeatmap;

  const CrowdStatusCard({
    super.key,
    required this.title,
    required this.description,
    required this.lastUpdated,
    required this.status,
    required this.onTapHeatmap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Colors.green.shade50,
            Colors.white,
          ],
        ),
        border: Border.all(
          color: Colors.green.shade100,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTapHeatmap,
        child: Row(
          children: [

            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.groups_rounded,
                color: Colors.green,
                size: 30,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    description,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Update $lastUpdated",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                CircleAvatar(
                  radius: 18,
                  backgroundColor: AppColor.primary.withOpacity(0.1),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 18,
                    color: AppColor.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}