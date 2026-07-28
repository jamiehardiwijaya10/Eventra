import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_color.dart';
import '../../../shared/widgets/navbar_costumer.dart';
import '../../../shared/widgets/category.dart';
import '../widgets/event_card.dart';
import '../widgets/event_card2.dart';

class HomeScreenCostumer extends StatefulWidget {
  const HomeScreenCostumer({super.key});

  @override
  State<HomeScreenCostumer> createState() => _HomeScreenCostumerState();
}

class _HomeScreenCostumerState extends State<HomeScreenCostumer> {
  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child:SingleChildScrollView(
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColor.primary,
                              AppColor.secondary,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        color: Colors.white.withOpacity(0.98),
                      ),
                    ),
                  ]
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 22,
                              backgroundImage: AssetImage(
                                "assets/images/Remielle Dan.jpg",
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Hi! Welcome\nRemielle",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),

                        Text(
                          "Current Location\nBandung, IDN",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search events...",
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.tune),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Popular Events 🔥",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),

                          const SizedBox(width: 100),

                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              "VIEW ALL",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 380,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        clipBehavior: Clip.none,
                        children: const [
                          SizedBox(width: 10),

                          FeaturedEventCard(
                            image: "assets/images/konser.png",
                            title: "Fleet Snowfluff's Concert",
                            date: "22 October 2026",
                            location: "Startoch Academy, Lahai Roi",
                          ),

                          SizedBox(width: 15),

                          FeaturedEventCard(
                            image: "assets/images/konser.png",
                            title: "Music Festival",
                            date: "24 October 2026",
                            location: "Ragunnna, Rinascita",
                          ),

                          SizedBox(width: 15),

                          FeaturedEventCard(
                            image: "assets/images/konser.png",
                            title: "Summer Festival",
                            date: "28 October 2026",
                            location: "Mengzhou, Huanglong",
                          ),

                          SizedBox(width: 20),
                        ],
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Choose by Category ✨",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            "VIEW ALL",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      clipBehavior: Clip.none,
                      child: Row(
                        children: [
                          CategoryChip(
                            icon: Icons.palette,
                            title: "Design",
                            selected: selectedCategory == 0,
                            onTap: () {
                              setState(() {
                                selectedCategory = 0;
                              });
                            },
                          ),

                          const SizedBox(width: 12),

                          CategoryChip(
                            icon: Icons.restaurant,
                            title: "Food",
                            selected: selectedCategory == 1,
                            onTap: () {
                              setState(() {
                                selectedCategory = 1;
                              });
                            },
                          ),

                          const SizedBox(width: 12),

                          CategoryChip(
                            icon: Icons.sports_soccer,
                            title: "Sport",
                            selected: selectedCategory == 2,
                            onTap: () {
                              setState(() {
                                selectedCategory = 2;
                              });
                            },
                          ),

                          const SizedBox(width: 12),

                          CategoryChip(
                            icon: Icons.music_note,
                            title: "Music",
                            selected: selectedCategory == 3,
                            onTap: () {
                              setState(() {
                                selectedCategory = 3;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),

                    const EventListCard(
                      image: "assets/images/konser.png",
                      title: "Fleet Snowfluff's Concert",
                      date: "22 October 2026",
                      location: "Bandung",
                      price: "\$10 USD",
                    ),

                    const EventListCard(
                      image: "assets/images/konser.png",
                      title: "Music Festival",
                      date: "24 October 2026",
                      location: "Jakarta",
                      price: "Free",
                    ),
                  ]
                ),
              ),
            ]
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(
        currentIndex: 0,
      ),
    );
  }
}