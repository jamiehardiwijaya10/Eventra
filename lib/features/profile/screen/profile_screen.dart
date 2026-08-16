import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';
import '../../../core/services/auth_services.dart';

import '../../../shared/widgets/navbar_costumer.dart' as customer_nav;

import '../../../shared/widgets/navbar_booth.dart' as booth_nav;

import '../../../shared/widgets/navbar_eo.dart' as eo_nav;

import '../widgets/profile_header.dart';
import '../widgets/profile_card.dart';
import '../widgets/profile_menu.dart';
import '../../../core/services/profile_service.dart';
import 'edit_profile_page.dart';
import 'history_page.dart';
import 'term_privacy_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();

  String? _role;
  Map<String, dynamic>? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final role = await _authService.getUserRole();
      final profile = await _profileService.getProfile();

      if (!mounted) return;

      setState(() {
        _role = role;
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("PROFILE ERROR: $e");

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });
    }
  }

  String get _fullName {
    final firstName = _profile?['first_name']?.toString() ?? '';

    final lastName = _profile?['last_name']?.toString() ?? '';

    final name = '$firstName $lastName'.trim();

    return name.isEmpty ? 'User' : name;
  }

  String get _email {
    return _authService.currentUser?.email ?? '-';
  }

  String get _avatarUrl {
    return _profile?['avatar_url']?.toString() ?? '';
  }

  Widget _buildNavbar() {
    switch (_role) {
      case "User":
        return const customer_nav.NavBar(currentIndex: 4);

      case "Booth Owner":
        return const booth_nav.NavBar(currentIndex: 4);

      case "EO":
        return const eo_nav.NavBar(currentIndex: 3);

      default:
        return const SizedBox.shrink();
    }
  }

  bool get _isBoothOwner => _role == "Booth Owner";
  String get _displayName {
    if (_isBoothOwner) {
      return _profile?['brand_name']?.toString() ?? '-';
    }

    final firstName = _profile?['first_name']?.toString() ?? '';
    final lastName = _profile?['last_name']?.toString() ?? '';

    final name = [
      firstName,
      lastName,
    ].where((name) => name.isNotEmpty).join(' ');

    return name.isEmpty ? '-' : name;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final menus = [
      ProfileMenuModel(
        icon: Icons.person_outline_rounded,
        title: "Edit Profile",
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditProfilePage(profile: _profile!),
            ),
          );

          if (result == true) {
            _loadProfile();
          }
        },
      ),
      ProfileMenuModel(
        icon: Icons.notifications_none_rounded,
        title: "Notifications",
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Notification feature belum tersedia."),
            ),
          );
        },
      ),
      ProfileMenuModel(
        icon: Icons.history_rounded,
        title: "History",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const HistoryPage()),
          );
        },
      ),
      ProfileMenuModel(
        icon: Icons.privacy_tip_outlined,
        title: "Terms & Privacy Policy",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TermsPrivacyPage()),
          );
        },
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
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileHeader(),

              const SizedBox(height: 28),

              ProfileCard(
                image: _avatarUrl,
                name: _displayName,
                email: _email,
                phone: _profile?['phone']?.toString() ?? '',

                companyName: _profile?['company_name']?.toString(),

                teamLeader: _profile?['team_leader']?.toString(),

                officialWebsite: _profile?['official_website']?.toString(),

                brandName: _profile?['brand_name']?.toString(),

                instagram: _profile?['ig']?.toString(),

                facebook: _profile?['facebook']?.toString(),

                tiktok: _profile?['tiktok']?.toString(),

                x: _profile?['x']?.toString(),

                isBoothOwner: _isBoothOwner,
                isEO: _role == "EO",
              ),

              const SizedBox(height: 30),

              ...menus.map((menu) => ProfileMenuCard(menu: menu)),
            ],
          ),
        ),
      ),
    );
  }
}
