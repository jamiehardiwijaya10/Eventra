import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';
import '../../../shared/widgets/navbar_costumer.dart';

import '../widgets/profile_header.dart';
import '../widgets/profile_card.dart';
import '../widgets/profile_menu.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final menus = [
      ProfileMenuModel(
        icon: Icons.person_outline_rounded,
        title: "Edit Profile",
        onTap: () {},
      ),
      ProfileMenuModel(
        icon: Icons.notifications_none_rounded,
        title: "Notifications",
        onTap: () {},
      ),
      ProfileMenuModel(
        icon: Icons.history_rounded,
        title: "History",
        onTap: () {},
      ),
      ProfileMenuModel(
        icon: Icons.privacy_tip_outlined,
        title: "Terms & Privacy Policy",
        onTap: () {},
      ),
      ProfileMenuModel(
        icon: Icons.logout_rounded,
        title: "Logout",
        onTap: () {},
      ),
    ];

    return Scaffold(
      backgroundColor: AppColor.white,

      bottomNavigationBar: const NavBar(
        currentIndex: 4,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            20,
            20,
            20,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const ProfileHeader(),

              const SizedBox(height: 28),

              const ProfileCard(
                image: "assets/images/Remielle Dan.jpg",
                name: "Remielle Dan",
                email: "Remie@gmail.com",
              ),

              const SizedBox(height: 30),

              ...menus.map(
                    (menu) => ProfileMenuCard(
                  menu: menu,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}