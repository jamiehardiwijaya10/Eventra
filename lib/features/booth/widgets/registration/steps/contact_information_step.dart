import 'package:flutter/material.dart';
import '../registration_textfield.dart';
import '../section_titles.dart';

class ContactInformationStep extends StatelessWidget {
  final TextEditingController ownerNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController instagramController;

  const ContactInformationStep({
    super.key,
    required this.ownerNameController,
    required this.phoneController,
    required this.emailController,
    required this.instagramController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const RegistrationSectionTitle(
          title: "Contact Information",
          subtitle:
          "Provide your contact information so the organizer can reach you.",
        ),

        RegistrationTextField(
          label: "Owner Name",
          hint: "Enter owner's full name",
          controller: ownerNameController,
          requiredField: true,
        ),

        RegistrationTextField(
          label: "Phone Number",
          hint: "08xxxxxxxxxx",
          controller: phoneController,
          keyboardType: TextInputType.phone,
          requiredField: true,
        ),

        RegistrationTextField(
          label: "Email Address",
          hint: "example@email.com",
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          requiredField: true,
        ),

        RegistrationTextField(
          label: "Instagram",
          hint: "@yourbooth",
          controller: instagramController,
          suffixIcon: const Icon(Icons.camera_alt_outlined),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}