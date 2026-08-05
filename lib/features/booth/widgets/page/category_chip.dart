import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_color.dart';


class BoothCategoryChip extends StatelessWidget {

  final String title;
  final bool selected;
  final VoidCallback onTap;


  const BoothCategoryChip({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onTap,

      child: Container(

        margin: const EdgeInsets.only(right:10),

        padding: const EdgeInsets.symmetric(
          horizontal:16,
          vertical:8,
        ),


        decoration: BoxDecoration(

          color: selected
              ? AppColor.primary
              : Colors.white,


          borderRadius:
          BorderRadius.circular(20),


          border: Border.all(

            color: selected
                ? AppColor.primary
                : Colors.grey.shade300,

          ),

        ),


        child: Text(

          title,


          style: GoogleFonts.poppins(

            fontSize:13,

            fontWeight:
            FontWeight.w500,


            color: selected
                ? Colors.white
                : Colors.black87,

          ),

        ),

      ),

    );

  }
}