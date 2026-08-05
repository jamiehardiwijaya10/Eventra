import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'booth_card.dart';

class PopularBoothSection extends StatelessWidget {

  final List<BoothModel> booths;

  const PopularBoothSection({
    super.key,
    required this.booths,
  });


  @override
  Widget build(BuildContext context) {

    final popularBooths = booths
        .where((booth) => booth.isPopular)
        .toList();


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        Row(
          children: [

            Text(
              "Popular Booth",
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


        const SizedBox(height:12),


        if(popularBooths.isEmpty)

          Text(
            "No popular booths yet",
            style: GoogleFonts.poppins(
              color: Colors.grey,
              fontSize:13,
            ),
          )


        else

          SizedBox(
            height:260,

            child: ListView.builder(

              scrollDirection: Axis.horizontal,

              itemCount: popularBooths.length,


              itemBuilder:(context,index){

                return BoothCard(
                  booth: popularBooths[index],

                  onTap:(){

                    // nanti masuk detail booth

                  },
                );

              },
            ),
          ),

      ],
    );
  }
}