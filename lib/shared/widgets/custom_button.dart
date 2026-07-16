import 'package:flutter/material.dart';
// import '../../core/theme/app_color.dart';
import '../../core/theme/app_text_style.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTextStyle.button,
        ),
      ),
    );
  }
}
