import 'dart:typed_data';

class RegistrationValidator {
  RegistrationValidator._();

  static String? validateBooth({
    required String boothName,
    required String? category,
    required String? businessType,
    required String description,
  }) {
    if (boothName.trim().isEmpty) {
      return "Booth name is required.";
    }

    if (category == null) {
      return "Please select booth category.";
    }

    if (businessType == null) {
      return "Please select business type.";
    }

    if (description.trim().isEmpty) {
      return "Description cannot be empty.";
    }

    return null;
  }

  static String? validateContact({
    required String owner,
    required String phone,
    required String email,
  }) {
    if (owner.trim().isEmpty) {
      return "Owner name is required.";
    }

    if (phone.trim().isEmpty) {
      return "Phone number is required.";
    }

    if (email.trim().isEmpty) {
      return "Email is required.";
    }

    final emailRegex = RegExp(
      r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return "Invalid email address.";
    }

    return null;
  }

  // ==========================================================
  // STEP 3
  // ==========================================================

  static String? validateUpload({
    Uint8List? logo,
    Uint8List? banner,
    Uint8List? booth,
  }) {
    if (logo == null) {
      return "Please upload booth logo.";
    }

    if (banner == null) {
      return "Please upload booth banner.";
    }

    if (booth == null) {
      return "Please upload booth photo.";
    }

    return null;
  }

  static String? validateAgreement({
    required bool agree,
  }) {
    if (!agree) {
      return "Please agree to the terms before submitting.";
    }

    return null;
  }
}