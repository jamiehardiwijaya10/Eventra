import 'package:flutter/material.dart';
import '../../core/theme/app_color.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          prefixIcon,
          color: AppColor.white,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColor.border,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColor.primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
