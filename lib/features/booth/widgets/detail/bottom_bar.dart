import 'package:flutter/material.dart';
import '../../../../core/theme/app_color.dart';

class BottomActionBar extends StatelessWidget {

  final bool isBookmarked;
  final VoidCallback onBookmark;
  final VoidCallback onNavigate;

  const BottomActionBar({
    super.key,
    required this.isBookmarked,
    required this.onBookmark,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: onBookmark,
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius:
                  BorderRadius.circular(18),
                ),

                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: [
                    Icon(
                      isBookmarked
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: AppColor.primary,
                    ),

                    const SizedBox(width: 8),

                    const Text(
                      "Simpan",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            flex: 2,
            child: InkWell(
              borderRadius:
              BorderRadius.circular(18),
              onTap: onNavigate,
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius:
                  BorderRadius.circular(18),
                ),

                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.navigation_rounded,
                      color: Colors.white,
                    ),

                    const SizedBox(width: 10),

                    const Text(
                      "Rute ke Booth",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}