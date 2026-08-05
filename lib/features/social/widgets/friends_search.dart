import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FriendsSearch extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const FriendsSearch({
    super.key,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,

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
            offset: const Offset(0, 4),
          )
        ],
      ),

      child: TextField(
        controller: controller,
        onChanged: onChanged,

        decoration: InputDecoration(
          border: InputBorder.none,

          prefixIcon: const Icon(Icons.search),

          hintText: "Search groups or friends...",

          hintStyle: GoogleFonts.poppins(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}