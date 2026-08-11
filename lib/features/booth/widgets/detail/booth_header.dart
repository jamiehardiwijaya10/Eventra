import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class BoothHeaderCard extends StatelessWidget {
  final String boothName;
  final String category;
  final String location;
  final String rating;
  final String reviewCount;
  final String queue;
  final String openHour;
  final String priceRange;
  final bool isOpen;

  const BoothHeaderCard({
    super.key,
    required this.boothName,
    required this.category,
    required this.location,
    required this.rating,
    required this.reviewCount,
    required this.queue,
    required this.openHour,
    required this.priceRange,
    required this.isOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        16,
        0,
        16,
        16,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      boothName,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [

                        Icon(
                          Icons.location_on,
                          color: AppColor.primary,
                          size: 18,
                        ),

                        const SizedBox(width: 4),

                        Expanded(
                          child: Text(
                            location,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        rating,
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(width: 4),

                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 28,
                      ),

                    ],
                  ),

                  Text(
                    "$reviewCount review",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isOpen
                      ? Colors.green
                      : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isOpen ? "OPEN" : "CLOSED",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Text(
                isOpen
                    ? "Buka sampai $openHour"
                    : "Sedang Tutup",
                style: TextStyle(
                  color: isOpen
                      ? Colors.green.shade700
                      : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Divider(
            color: Colors.grey.shade300,
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  icon: Icons.groups,
                  title: queue,
                  subtitle: "Estimasi antrian",
                ),
              ),

              Expanded(
                child: _InfoItem(
                  icon: Icons.access_time,
                  title: openHour,
                  subtitle: "Jam operasional",
                ),
              ),

              Expanded(
                child: _InfoItem(
                  icon: Icons.sell_outlined,
                  title: priceRange,
                  subtitle: "Kisaran harga",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: AppColor.primary,
          size: 30,
        ),

        const SizedBox(height: 10),

        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}