import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryEvent {

  final String image;
  final String title;
  final String location;
  final String date;
  final bool attended;

  const HistoryEvent({
    required this.image,
    required this.title,
    required this.location,
    required this.date,
    required this.attended,
  });

}

class HistoryCard extends StatelessWidget {

  final HistoryEvent event;
  final VoidCallback onTap;

  const HistoryCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(

      onTap: onTap,

      borderRadius: BorderRadius.circular(20),

      child: Container(

        margin: const EdgeInsets.only(bottom: 16),

        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.04),
              blurRadius: 10,
              offset: const Offset(0,4),
            )
          ],
        ),

        child: Row(

          children: [

            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                event.image,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width:16),

            Expanded(

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    event.title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height:8),

                  Row(
                    children: [

                      const Icon(
                        Icons.location_on_outlined,
                        size:16,
                        color: Colors.grey,
                      ),

                      const SizedBox(width:4),

                      Expanded(
                        child: Text(
                          event.location,
                          style: GoogleFonts.poppins(
                            fontSize:12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height:5),

                  Row(
                    children: [

                      const Icon(
                        Icons.calendar_today_outlined,
                        size:15,
                        color: Colors.grey,
                      ),

                      const SizedBox(width:4),

                      Text(
                        event.date,
                        style: GoogleFonts.poppins(
                          fontSize:12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height:10),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal:10,
                      vertical:5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      event.attended
                          ? "Attended"
                          : "Expired",
                      style: GoogleFonts.poppins(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                        fontSize:11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}