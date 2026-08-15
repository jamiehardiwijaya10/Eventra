import 'package:flutter/material.dart';

import '../../../../core/theme/app_color.dart';

class BottomActionBar extends StatelessWidget {
  final VoidCallback onNavigate;

  const BottomActionBar({
    super.key,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          16,
          10,
          16,
          12,
        ),

        decoration: BoxDecoration(
          color: Colors.white,

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),

        child: SizedBox(
          width: double.infinity,

          child: ElevatedButton.icon(
            onPressed: onNavigate,

            icon: const Icon(
              Icons.directions,
              size: 21,
            ),

            label: const Text(
              'Rute ke Booth',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
              ),
            ),

            style: ElevatedButton.styleFrom(
              backgroundColor:
              AppColor.primary,

              foregroundColor:
              Colors.white,

              elevation: 0,

              padding:
              const EdgeInsets.symmetric(
                vertical: 15,
              ),

              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}