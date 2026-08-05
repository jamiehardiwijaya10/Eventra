import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_color.dart';

class EventMenu {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const EventMenu({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class EventMenuSection extends StatelessWidget {
  final List<EventMenu> menus;

  const EventMenuSection({
    super.key,
    required this.menus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          "Explore This Event",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          "Everything you need in one place.",
          style: GoogleFonts.poppins(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 20),

        GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: menus.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: 95,
          ),
          itemBuilder: (context, index) {

            final menu = menus[index];

            return InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: menu.onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Colors.grey.shade200,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),

                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [

                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: AppColor.primary.withOpacity(0.80),
                        borderRadius:
                        BorderRadius.circular(16),
                      ),
                      child: Icon(
                        menu.icon,
                        color: AppColor.white,
                        size: 28,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      menu.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}