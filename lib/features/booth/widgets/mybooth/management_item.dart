import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BoothManagementModel {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;

  const BoothManagementModel({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
  });
}

class BoothManagementItem extends StatelessWidget {
  final BoothManagementModel item;

  const BoothManagementItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: item.onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: item.color.withOpacity(.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  item.icon,
                  color: item.color,
                ),
              ),

              const Spacer(),

              Text(
                item.title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}