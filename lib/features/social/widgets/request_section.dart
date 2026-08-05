import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'request_card.dart';

class FriendRequestSection extends StatelessWidget {

  final List<FriendRequestModel> requests;

  const FriendRequestSection({
    super.key,
    required this.requests,
  });


  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,

      children:[

        Row(
          children:[

            Text(
              "Friend Requests",
              style:GoogleFonts.poppins(
                fontSize:18,
                fontWeight:FontWeight.bold,
              ),
            ),

            const SizedBox(width:8),

            Container(
              padding:const EdgeInsets.symmetric(
                horizontal:10,
                vertical:4,
              ),

              decoration:BoxDecoration(
                color:Colors.orange.shade50,
                borderRadius:BorderRadius.circular(20),
              ),

              child:Text(
                requests.length.toString(),
                style:GoogleFonts.poppins(
                  fontSize:12,
                  fontWeight:FontWeight.bold,
                ),
              ),
            ),

            const Spacer(),

            TextButton(
              onPressed:(){},
              child:const Text("See All"),
            ),
          ],
        ),


        const SizedBox(height:16),

        ...requests.map(
              (request)=>FriendRequestCard(
            request:request,
            onAccept:(){},
            onDecline:(){},
          ),
        ),
      ],
    );
  }
}