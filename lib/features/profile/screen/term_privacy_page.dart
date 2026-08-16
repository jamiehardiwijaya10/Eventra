import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';

class TermsPrivacyPage extends StatelessWidget {
  const TermsPrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F8FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Terms & Privacy Policy",
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey.shade200,
            ),
          ),
          child: const Text(
            """
ISI TERMS & PRIVACY POLICY DI SINI

Ganti seluruh teks ini dengan isi Terms & Privacy Policy milik kamu.

Contoh:

1. Terms of Service

Isi terms of service kamu di sini.

2. Privacy Policy

Isi privacy policy kamu di sini.

3. User Responsibilities

Isi ketentuan pengguna kamu di sini.

4. Data Privacy

Isi ketentuan mengenai data pengguna kamu di sini.

5. Changes to Policy

Isi ketentuan perubahan kebijakan kamu di sini.
""",
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
