import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';
import '../../app/routes.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;

  const NavBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: AppColor.primary,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,

        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.homecostumer,
              );
              break;

            case 1:
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.event,
              );
              break;

            case 2:
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.friendspage,
              );
              break;

            case 3:
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.boothpage,
              );
              break;

            case 4:
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.profilecostumer,
              );
              break;
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: "Event",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum_outlined),
            label: "Friends & Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            label: "Booth",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}