import 'package:flutter/material.dart';
import '../theme/app_color.dart';

class AppTextStyle {
  AppTextStyle._();

  static const TextStyle title = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColor.white,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColor.black,
  );

  static const TextStyle body = TextStyle(fontSize: 16, color: AppColor.black);

  static const TextStyle subtitle = TextStyle(
    fontSize: 14,
    color: AppColor.grey,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColor.white,
  );

}
