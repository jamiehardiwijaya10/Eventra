import 'dart:io';

import 'package:flutter/material.dart';

class CreateEventValidator {
  static String? validateStep1({
    required String eventName,
    required String? category,
    required File? banner,
    required File? logo,
  }) {
    if (eventName.trim().isEmpty) {
      return "Event name cannot be empty.";
    }

    if (eventName.trim().length < 3) {
      return "Event name must contain at least 3 characters.";
    }

    if (category == null) {
      return "Please select an event category.";
    }

    if (banner == null) {
      return "Please upload an event banner.";
    }

    if (logo == null) {
      return "Please upload an event logo.";
    }

    return null;
  }

  static String? validateStep2({
    required bool isIndoor,
    required String venue,
    required String address,
    required DateTime? startDate,
    required DateTime? endDate,
    required TimeOfDay? openingTime,
    required TimeOfDay? closingTime,
    required File? floorplan,
  }) {
    if (venue.trim().isEmpty) {
      return "Venue name cannot be empty.";
    }

    if (address.trim().isEmpty) {
      return "Venue address cannot be empty.";
    }

    if (startDate == null) {
      return "Please select the event start date.";
    }

    if (endDate == null) {
      return "Please select the event end date.";
    }

    if (endDate.isBefore(startDate)) {
      return "End date cannot be earlier than the start date.";
    }

    if (openingTime == null) {
      return "Please select the opening time.";
    }

    if (closingTime == null) {
      return "Please select the closing time.";
    }

    final openMinutes =
        openingTime.hour * 60 + openingTime.minute;

    final closeMinutes =
        closingTime.hour * 60 + closingTime.minute;

    if (closeMinutes <= openMinutes) {
      return "Closing time must be after opening time.";
    }

    if (isIndoor && floorplan == null) {
      return "Please upload the venue floor plan.";
    }

    return null;
  }

  static String? validateStep3({
    required String maximumBooth,
    required String registrationFee,
    required DateTime? registrationDeadline,
    required DateTime? startDate,
    required List<String> categories,
  }) {
    if (maximumBooth.isEmpty) {
      return "Maximum booth cannot be empty.";
    }

    final booth = int.tryParse(maximumBooth);

    if (booth == null || booth <= 0) {
      return "Maximum booth must be greater than 0.";
    }

    if (registrationFee.isEmpty) {
      return "Registration fee cannot be empty.";
    }

    final fee = int.tryParse(registrationFee);

    if (fee == null || fee < 0) {
      return "Registration fee is invalid.";
    }

    if (registrationDeadline == null) {
      return "Please select the registration deadline.";
    }

    if (startDate != null &&
        registrationDeadline.isAfter(startDate)) {
      return "Registration deadline must be before the event starts.";
    }

    if (categories.isEmpty) {
      return "Please select at least one booth category.";
    }

    return null;
  }

  static String? validateStep4({
    required bool agree,
  }) {
    if (!agree) {
      return "Please confirm all event information.";
    }

    return null;
  }
}