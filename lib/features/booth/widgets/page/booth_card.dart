import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_color.dart';

class BoothModel {
  final String id;
  final String image;
  final String name;
  final String category;
  final String description;
  final double rating;
  final int totalEvent;
  final bool isPopular;
  final Map<String, dynamic> data;

  const BoothModel({
    required this.id,
    required this.image,
    required this.name,
    required this.category,
    required this.description,
    required this.rating,
    required this.totalEvent,
    required this.isPopular,
    required this.data,
  });
}

class BoothCard extends StatelessWidget {

  final BoothModel booth;
  final VoidCallback onTap;

  const BoothCard({
    super.key,
    required this.booth,
    required this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius:
      BorderRadius.circular(20),
      onTap:onTap,
      child: Container(
        width:230,
        margin:
        const EdgeInsets.only(
          right:16,
          bottom:16,
        ),
        padding:
        const EdgeInsets.all(12),
        decoration:BoxDecoration(
          color:Colors.white,
          borderRadius:
          BorderRadius.circular(20),
          border:
          Border.all(
            color:
            Colors.grey.shade200,
          ),
          boxShadow:[
            BoxShadow(
              color:
              Colors.black.withOpacity(.05),
              blurRadius:10,
              offset:
              const Offset(0,4),
            )
          ],
        ),
        child:Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          mainAxisSize:
          MainAxisSize.min,
          children:[
            ClipRRect(
              borderRadius:
              BorderRadius.circular(16),
              child:SizedBox(
                height:105,
                width:double.infinity,
                child:Image.network(
                  booth.image,
                  fit:BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height:8),

            Text(
              booth.name,
              maxLines:1,
              overflow:
              TextOverflow.ellipsis,
              style:
              GoogleFonts.poppins(
                fontSize:15,
                fontWeight:
                FontWeight.w600,
              ),
            ),

            const SizedBox(height:4),

            Text(
              booth.category,
              style:
              GoogleFonts.poppins(
                fontSize:12,
                color:
                AppColor.primary,
                fontWeight:
                FontWeight.w500,
              ),
            ),

            const SizedBox(height:6),

            Text(
              booth.description,
              maxLines:2,
              overflow:
              TextOverflow.ellipsis,
              style:
              GoogleFonts.poppins(
                fontSize:12,
                color:
                Colors.grey,
              ),
            ),

            const SizedBox(height:5),

            Row(
              children:[
                const Icon(
                  Icons.star,
                  size:16,
                  color:Colors.orange,
                ),
                const SizedBox(width:4),
                Text(
                  booth.rating.toString(),
                  style:
                  GoogleFonts.poppins(
                    fontSize:12,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const Spacer(),

                Icon(
                  Icons.arrow_forward_ios,
                  size:14,
                  color:
                  Colors.grey,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}