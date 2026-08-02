import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_color.dart';

class EventActionBar extends StatelessWidget {
  final bool bookmarked;
  final String buttonText;

  final VoidCallback onBookmark;
  final VoidCallback onPressed;

  const EventActionBar({
    super.key,
    required this.bookmarked,
    required this.buttonText,
    required this.onBookmark,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [

            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: onBookmark,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppColor.primary,
                  ),
                ),
                child: Icon(
                  bookmarked
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: AppColor.primary,
                ),
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: SizedBox(
                height: 60,
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: AppColor.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(18),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}