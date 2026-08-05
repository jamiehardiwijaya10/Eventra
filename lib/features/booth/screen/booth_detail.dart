import 'package:flutter/material.dart';

import '../../../core/theme/app_color.dart';
import '../widgets/detail/bottom_bar.dart';
import '../widgets/detail/booth_header.dart';
import '../widgets/detail/booth_image.dart';
import '../widgets/detail/crowd_status.dart';
import '../widgets/detail/menu_card.dart';
import '../widgets/detail/payment_method.dart';

class BoothDetailPage extends StatefulWidget {
  const BoothDetailPage({super.key});

  @override
  State<BoothDetailPage> createState() => _BoothDetailPageState();
}

class _BoothDetailPageState extends State<BoothDetailPage> {
  bool isBookmarked = false;
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      bottomNavigationBar: BottomActionBar(
        isBookmarked: isBookmarked,
        onBookmark: () {
          setState(() {
            isBookmarked = !isBookmarked;
          });
        },
        onNavigate: () {},
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
          DraggableScrollableSheet(
            initialChildSize: 0.72,
            minChildSize: 0.65,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
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
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TabBar(
                          controller: TabController(
                            length: 2,
                            vsync: Scaffold.of(context),
                            initialIndex: selectedTab,
                          ),
                          onTap: (index) {
                            setState(() {
                              selectedTab = index;
                            });
                          },
                          labelColor: AppColor.primary,
                          unselectedLabelColor: Colors.grey,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          dividerColor: Colors.transparent,
                          tabs: const [
                            Tab(text: "Menu"),
                            Tab(text: "Review"),
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
          description: "Burger sapi dengan saus spesial.",
          price: "Rp45.000",
          rating: 4.8,
          isPopular: true,
        ),

        MenuCard(
          image: "assets/images/burger.png",
          name: "French Fries",
          description: "Kentang goreng renyah.",
          price: "Rp20.000",
          rating: 4.7,
        ),

        MenuCard(
          image: "assets/images/burger.png",
          name: "McFlurry",
          description: "Es krim dengan topping.",
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
          comment: "Booth mudah ditemukan dan pelayanan cepat.",
        ),

        ReviewBox(
          name: "Budi",
          rating: 4,
          comment: "Navigasi Eventra sangat membantu.",
        ),

        ReviewBox(
          name: "Rina",
          rating: 5,
          comment: "Informasi booth cukup lengkap.",
        ),
      ],
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
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
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
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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