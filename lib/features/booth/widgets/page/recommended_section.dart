import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'booth_card.dart';

class RecommendedBoothSection extends StatelessWidget {

  final List<BoothModel> booths;

  const RecommendedBoothSection({
    super.key,
    required this.booths,
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Row(
          children: [

            Text(
              "Recommended Booth",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            TextButton(
              onPressed: () {},
              child: Text(
                "See All",
                style: GoogleFonts.poppins(
                  color: Colors.orange,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          ],
        ),


        const SizedBox(height: 12),


        if (booths.isEmpty)

          Text(
            "No recommended booths available",
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize: 13,
            ),
          )

        else

          SizedBox(
            height: 260,

            child: ListView.builder(

              scrollDirection: Axis.horizontal,

              itemCount: booths.length,

              itemBuilder: (context,index){

                return BoothCard(
                  booth: booths[index],
                  onTap: () {

                    // nanti ke booth detail

                  },
                );

              },
            ),
          ),
      ],
    );
  }
}