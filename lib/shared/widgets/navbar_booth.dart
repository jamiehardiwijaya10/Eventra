import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../core/theme/app_color.dart';

class NavBar extends StatelessWidget {
  final int currentIndex;

  const NavBar({
    super.key,
    required this.currentIndex,
  });

  void _navigate(BuildContext context, int index) {
    if (index == currentIndex) return;

    String page = "";

    switch (index) {
      case 0:
         Navigator.pushReplacementNamed(
                context,
                AppRoutes.homebooth,
              );
        break;

      case 1:
         Navigator.pushReplacementNamed(
                context,
                AppRoutes.registerEventBooth,
              );
        break;

      case 3:
         Navigator.pushReplacementNamed(
                context,
                AppRoutes.mybooth,
              );
        break;

      case 4:
         Navigator.pushReplacementNamed(
                context,
                AppRoutes.profilecostumer,
              );
        break;
    }
  }

  Widget _buildItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool selected = currentIndex == index;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _navigate(context, index),
        child: SizedBox(
          height: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 25,
                color: selected ? AppColor.primary : Colors.black54,
              ),

              const SizedBox(height: 3),

              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: selected ? AppColor.primary : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      elevation: 10,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,

      child: SizedBox(
        height: 70,
        child: Row(
          children: [

            _buildItem(
              context: context,
              icon: Icons.home,
              label: "Home",
              index: 0,
            ),

            _buildItem(
              context: context,
              icon: Icons.event,
              label: "Event",
              index: 1,
            ),

            const SizedBox(width: 75),

            _buildItem(
              context: context,
              icon: Icons.storefront_outlined,
              label: "My Booth",
              index: 3,
            ),

            _buildItem(
              context: context,
              icon: Icons.person,
              label: "Profile",
              index: 4,
            ),
          ],
        ),
      ),
    );
  }
}