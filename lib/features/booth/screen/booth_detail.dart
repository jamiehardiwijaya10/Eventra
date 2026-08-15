import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';
import '../widgets/detail/bottom_bar.dart';
import '../widgets/detail/booth_header.dart';
import '../widgets/detail/booth_image.dart';
import '../widgets/detail/crowd_status.dart';
import '../widgets/detail/menu_card.dart';
import '../widgets/detail/payment_method.dart';

class BoothDetailPage extends StatefulWidget {
  final Map<String, dynamic> booth;
  final bool isManagement;

  const BoothDetailPage({
    super.key,
    required this.booth,
    this.isManagement = false,
  });

  @override
  State<BoothDetailPage> createState() =>
      _BoothDetailPageState();
}

class _BoothDetailPageState extends State<BoothDetailPage> {
  bool isBookmarked = false;
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      bottomNavigationBar: BottomActionBar(
        onNavigate: () {
        },
      ),

      body: Stack(
        children: [

          SizedBox(
            height: 350,
            width: double.infinity,
            child: BoothImageCarousel(
              images: const [
                "assets/images/burger.png",
                "assets/images/burger.png",
                "assets/images/burger.png",
              ],
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isBookmarked = !isBookmarked;
                  });
                },
                icon: Icon(
                  isBookmarked
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: AppColor.primary,
                ),
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.72,
            minChildSize: 0.65,
            maxChildSize: 0.95,

            builder: (
                context,
                scrollController,
                ) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),

                child: SingleChildScrollView(
                  controller: scrollController,

                  padding: const EdgeInsets.only(
                    top: 20,
                    bottom: 120,
                  ),

                  child: Column(
                    children: [

                      BoothHeaderCard(
                        boothName: "Stand McDonald's",
                        category: "Fast Food",
                        location: "Festival Kuliner Bandung",
                        rating: "4.6",
                        reviewCount: "128",
                        queue: "1-10 orang",
                        openHour: "20.00 - 22.00",
                        priceRange: "30K - 80K",
                        isOpen: true,
                      ),

                      const SizedBox(height: 16),

                      Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius:
                          BorderRadius.circular(16),
                        ),

                        child: Row(
                          children: [
                            _TabButton(
                              title: "Menu",
                              isSelected:
                              selectedTab == 0,
                              onTap: () {
                                setState(() {
                                  selectedTab = 0;
                                });
                              },
                            ),

                            _TabButton(
                              title: "Review",
                              isSelected:
                              selectedTab == 1,
                              onTap: () {
                                setState(() {
                                  selectedTab = 1;
                                });
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      if (selectedTab == 0)
                        _menuContent(),

                      if (selectedTab == 1)
                        _reviewContent(),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _menuContent() {
    return Column(
      children: [

        CrowdStatusCard(
          title: "Antrian Sedang Sepi",
          description: "Estimasi tunggu ±5 menit",
          lastUpdated: "2 menit lalu",
          status: "SEPI",
          onTapHeatmap: () {},
        ),

        const SizedBox(height: 4),

        const _SectionTitle(
          title: "Ketersediaan Menu",
        ),

        _StockStatusCard(
          name: "Big Mac",
          status: "TERSEDIA",
          quantityText: "Tersedia",
        ),

        _StockStatusCard(
          name: "French Fries",
          status: "HAMPIR HABIS",
          quantityText: "Sisa 5 porsi",
        ),

        _StockStatusCard(
          name: "McFlurry",
          status: "HABIS",
          quantityText: "Tidak tersedia",
        ),

        const SizedBox(height: 8),

        PaymentMethodCard(
          paymentMethods: const [
            "Cash",
            "QRIS",
            "GoPay",
            "DANA",
            "BCA",
          ],
        ),

        const _SectionTitle(
          title: "Menu Booth",
        ),

        MenuCard(
          image: "assets/images/burger.png",
          name: "Big Mac",
          description:
          "Burger sapi dengan saus spesial.",
          price: "Rp45.000",
          rating: 4.8,
          isPopular: true,
        ),

        MenuCard(
          image: "assets/images/burger.png",
          name: "French Fries",
          description:
          "Kentang goreng renyah.",
          price: "Rp20.000",
          rating: 4.7,
        ),

        MenuCard(
          image: "assets/images/burger.png",
          name: "McFlurry",
          description:
          "Es krim dengan topping.",
          price: "Rp15.000",
          rating: 4.6,
        ),
      ],
    );
  }

  Widget _reviewContent() {
    return Column(
      children: [

        const _SectionTitle(
          title: "Review Pengunjung",
        ),

        ReviewBox(
          name: "Andi",
          rating: 5,
          comment:
          "Booth mudah ditemukan dan pelayanan cepat.",
        ),

        ReviewBox(
          name: "Budi",
          rating: 4,
          comment:
          "Navigasi Eventra sangat membantu.",
        ),

        ReviewBox(
          name: "Rina",
          rating: 5,
          comment:
          "Informasi booth cukup lengkap.",
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,

        child: Container(
          margin: const EdgeInsets.all(4),

          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white
                : Colors.transparent,

            borderRadius:
            BorderRadius.circular(13),

            boxShadow: isSelected
                ? const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ]
                : null,
          ),

          alignment: Alignment.center,

          child: Text(
            title,

            style: TextStyle(
              color: isSelected
                  ? AppColor.primary
                  : Colors.grey,

              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _StockStatusCard extends StatelessWidget {
  final String name;
  final String status;
  final String quantityText;

  const _StockStatusCard({
    required this.name,
    required this.status,
    required this.quantityText,
  });

  @override
  Widget build(BuildContext context) {
    final bool available =
        status == "TERSEDIA";

    final bool almostEmpty =
        status == "HAMPIR HABIS";

    Color statusColor;

    if (available) {
      statusColor = Colors.green;
    } else if (almostEmpty) {
      statusColor = Colors.orange;
    } else {
      statusColor = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 5,
      ),

      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.grey.shade50,

        borderRadius:
        BorderRadius.circular(14),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Row(
        children: [

          Container(
            width: 42,
            height: 42,

            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.10),
              borderRadius:
              BorderRadius.circular(12),
            ),

            child: Icon(
              available
                  ? Icons.check_circle_outline
                  : almostEmpty
                  ? Icons.warning_amber_rounded
                  : Icons.cancel_outlined,

              color: statusColor,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  name,

                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  quantityText,

                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12.5,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 6,
            ),

            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.10),
              borderRadius:
              BorderRadius.circular(20),
            ),

            child: Text(
              status,

              style: TextStyle(
                color: statusColor,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        8,
      ),

      child: Align(
        alignment: Alignment.centerLeft,

        child: Text(
          title,

          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class ReviewBox extends StatelessWidget {
  final String name;
  final double rating;
  final String comment;

  const ReviewBox({
    super.key,
    required this.name,
    required this.rating,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          Row(
            children: [

              Text(
                name,

                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),

              Text("⭐ $rating"),
            ],
          ),

          const SizedBox(height: 8),

          Text(comment),
        ],
      ),
    );
  }
}