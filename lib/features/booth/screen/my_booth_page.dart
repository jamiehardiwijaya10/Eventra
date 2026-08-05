import 'package:flutter/material.dart';
import '../../../shared/widgets/navbar_booth.dart';
import '../widgets/mybooth/header_card.dart';
import '../widgets/mybooth/current_card.dart';
import '../widgets/mybooth/booth_stats.dart';
import '../widgets/mybooth/management_item.dart';
import '../widgets/mybooth/booth_management.dart';
import '../widgets/mybooth/statistik_booth.dart';
import '../../../core/theme/app_color.dart';

class MyBoothPage extends StatelessWidget {
  const MyBoothPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        title: const Text("My Booth"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      floatingActionButton: SizedBox(
        width: 72,
        height: 72,
        child: FloatingActionButton(
          elevation: 8,
          backgroundColor: AppColor.primary,
          shape: const CircleBorder(),
          onPressed: () {
          },
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 34,
          ),
        ),
      ),

      floatingActionButtonLocation:
      FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: const NavBar(
        currentIndex: 3,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            BoothHeaderCard(
              booth: const BoothHeaderModel(
                image: "assets/images/burger.png",
                name: "Burger Kingdom",
                category: "Fast Food & Beverage",
                isOpen: true,
              ),
            ),

            const SizedBox(height: 24),

            CurrentEventCard(
              event: const CurrentEventModel(
                eventName: "Bandung Food Festival",
                boothNumber: "Booth A-12",
                date: "20 - 22 October 2026",
                location: "Braga, Bandung",
                isActive: true,
              ),

              onViewEvent: () {},

              onViewMap: () {},

              onShowQR: () {},
            ),

            const SizedBox(height: 30),

            BoothStatistics(
              stats: const [

                BoothStatModel(
                  icon: Icons.star,
                  title: "Rating",
                  value: "4.8",
                  color: Colors.amber,
                ),

                BoothStatModel(
                  icon: Icons.reviews,
                  title: "Reviews",
                  value: "245",
                  color: Colors.blue,
                ),

                BoothStatModel(
                  icon: Icons.fastfood,
                  title: "Products",
                  value: "18",
                  color: Colors.orange,
                ),

                BoothStatModel(
                  icon: Icons.bookmark,
                  title: "Bookmarks",
                  value: "512",
                  color: Colors.red,
                ),
              ],
            ),

            const SizedBox(height: 30),

            BoothManagementGrid(
              items: [

                BoothManagementModel(
                  icon: Icons.edit_outlined,
                  title: "Edit Booth",
                  color: Colors.blue,
                  onTap: () {},
                ),

                BoothManagementModel(
                  icon: Icons.fastfood_outlined,
                  title: "Products",
                  color: Colors.orange,
                  onTap: () {},
                ),

                BoothManagementModel(
                  icon: Icons.photo_library_outlined,
                  title: "Gallery",
                  color: Colors.purple,
                  onTap: () {},
                ),

                BoothManagementModel(
                  icon: Icons.star_outline,
                  title: "Reviews",
                  color: Colors.amber,
                  onTap: () {},
                ),

                BoothManagementModel(
                  icon: Icons.qr_code_2_outlined,
                  title: "QR Booth",
                  color: Colors.green,
                  onTap: () {},
                ),

                BoothManagementModel(
                  icon: Icons.visibility_outlined,
                  title: "Visitor Preview",
                  color: Colors.teal,
                  onTap: () {},
                ),

                BoothManagementModel(
                  icon: Icons.settings_outlined,
                  title: "Settings",
                  color: Colors.grey,
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}