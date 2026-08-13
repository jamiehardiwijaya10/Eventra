import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/services/auth_services.dart';

import '../../../shared/widgets/navbar_costumer.dart'
    as customer_nav;

import '../../../shared/widgets/navbar_booth.dart'
    as booth_nav;

import '../../../shared/widgets/navbar_eo.dart'
    as eo_nav;

import '../widgets/profile_header.dart';
import '../widgets/profile_card.dart';
import '../widgets/profile_menu.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();

  String? _role;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRole();
  }

  Future<void> _loadRole() async {
    try {
      final role = await _authService.getUserRole();

      if (!mounted) return;

      setState(() {
        _role = role;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("PROFILE ROLE ERROR: $e");

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildNavbar() {
    switch (_role) {
      case "User":
        return const customer_nav.NavBar(
          currentIndex: 4,
        );

      case "Booth Owner":
        return const booth_nav.NavBar(
          currentIndex: 4,
        );

      case "EO":
        return const eo_nav.NavBar(
          currentIndex: 3,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
        onTap: () async {
          await _authService.logout();

          if (!context.mounted) return;

          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        },
      ),
    ];

    return Scaffold(
      backgroundColor: AppColor.white,

      bottomNavigationBar: _buildNavbar(),

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