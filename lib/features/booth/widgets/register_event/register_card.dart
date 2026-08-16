import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_color.dart';

class EventRegisterModel {
  final String eventId;
  final String image;
  final String title;
  final String date;
  final String location;
  final int totalBooth;
  final bool registrationOpen;
  final String? category;
  final DateTime? registrationDeadline;
  final DateTime? startDate;

  EventRegisterModel({
    required this.eventId,
    required this.image,
    required this.title,
    required this.date,
    required this.location,
    required this.totalBooth,
    required this.registrationOpen,
    this.category,
    this.registrationDeadline,
    this.startDate,
  });

  bool get isClosingSoon {
    if (registrationDeadline == null) {
      return false;
    }

    final now = DateTime.now();

    final difference =
        registrationDeadline!.difference(now);

    return difference.inDays >= 0 &&
        difference.inDays <= 3;
  }

  bool get isUpcoming {
    if (startDate == null) {
      return false;
    }

    return startDate!.isAfter(DateTime.now());
  }
}

class EventRegisterCard extends StatelessWidget {
  final EventRegisterModel event;
  final VoidCallback onRegister;

  const EventRegisterCard({
    super.key,
    required this.event,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    String statusText;
    Color statusColor;
    Color statusBackground;

    if (!event.registrationOpen) {
      statusText = "Registration Closed";
      statusColor = Colors.red.shade700;
      statusBackground = Colors.red.shade100;
    } else if (event.isUpcoming) {
      statusText = "Upcoming";
      statusColor = Colors.blue.shade700;
      statusBackground = Colors.blue.shade100;
    } else if (event.isClosingSoon) {
      statusText = "Closing Soon";
      statusColor = Colors.orange.shade700;
      statusBackground = Colors.orange.shade100;
    } else {
      statusText = "Open Registration";
      statusColor = Colors.green.shade700;
      statusBackground = Colors.green.shade100;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(22),
            ),
            child: event.image.isEmpty
                ? Container(
                    height: 170,
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.image_not_supported_outlined,
                      size: 50,
                      color: Colors.grey,
                    ),
                  )
                : Image.network(
                    event.image,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) {
                      return Container(
                        height: 170,
                        width: double.infinity,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: statusBackground,
                        borderRadius:
                            BorderRadius.circular(30),
                      ),
                      child: Text(
                        statusText,
                        style: GoogleFonts.poppins(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                      ),
                    ),

                    if (event.category != null &&
                        event.category!.isNotEmpty) ...[
                      const SizedBox(width: 8),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.primary
                              .withOpacity(.10),
                          borderRadius:
                              BorderRadius.circular(30),
                        ),
                        child: Text(
                          event.category!,
                          style: GoogleFonts.poppins(
                            color: AppColor.primary,
                            fontWeight:
                                FontWeight.w600,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 12),

                Text(
                  event.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.date,
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(
                      Icons.storefront_outlined,
                      size: 17,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${event.totalBooth} Booth Registered",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed:
                        event.registrationOpen &&
                                !event.isUpcoming
                            ? onRegister
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColor.primary,
                      disabledBackgroundColor:
                          Colors.grey.shade300,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      event.isUpcoming
                          ? "Coming Soon"
                          : event.registrationOpen
                              ? "Register Booth"
                              : "Registration Closed",
                      style: GoogleFonts.poppins(
                        fontWeight:
                            FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
