import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_color.dart';

class FriendRequestModel {
  final String image;
  final String name;
  final String subtitle;

  const FriendRequestModel({
    required this.image,
    required this.name,
    required this.subtitle,
  });
}


class FriendRequestCard extends StatelessWidget {

  final FriendRequestModel request;
  final VoidCallback onAccept;
  final VoidCallback onDecline;

  const FriendRequestCard({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onDecline,
  });


  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.only(bottom:14),
      padding: const EdgeInsets.all(14),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: Colors.grey.shade200,
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius:10,
            offset:const Offset(0,4),
          ),
        ],
      ),


      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [

          CircleAvatar(
            radius:28,
            backgroundImage:AssetImage(request.image),
          ),


          const SizedBox(width:14),


          Expanded(
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start,

              children:[

                Text(
                  request.name,

                  style:GoogleFonts.poppins(
                    fontSize:15,
                    fontWeight:FontWeight.w600,
                  ),
                ),


                const SizedBox(height:4),


                Text(
                  request.subtitle,

                  maxLines:2,
                  overflow:TextOverflow.ellipsis,

                  style:GoogleFonts.poppins(
                    fontSize:12,
                    color:Colors.grey,
                  ),
                ),
              ],
            ),
          ),


          const SizedBox(width:10),


          Column(
            children:[

              SizedBox(
                width:80,
                height:34,

                child:ElevatedButton(

                  onPressed:onAccept,

                  style:ElevatedButton.styleFrom(

                    backgroundColor:
                    AppColor.primary,

                    elevation:0,

                    padding:EdgeInsets.zero,

                    shape:RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),


                  child:Text(
                    "Accept",

                    style:GoogleFonts.poppins(
                      color:Colors.white,
                      fontSize:11,
                      fontWeight:FontWeight.w500,
                    ),
                  ),
                ),
              ),


              const SizedBox(height:8),


              SizedBox(
                width:80,
                height:34,

                child:OutlinedButton(

                  onPressed:onDecline,

                  style:OutlinedButton.styleFrom(

                    padding:EdgeInsets.zero,

                    shape:RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),


                  child:Text(
                    "Decline",

                    style:GoogleFonts.poppins(
                      fontSize:11,
                      fontWeight:FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}