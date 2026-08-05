import 'package:flutter/material.dart';
import '../../../core/theme/app_color.dart';

class ChatTabBar extends StatelessWidget {

  final int currentIndex;
  final Function(int) onChanged;

  const ChatTabBar({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      height: 52,

      padding: const EdgeInsets.all(4),

      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(

        children: [

          Expanded(
            child: _TabButton(
              text: "Groups",
              selected: currentIndex == 0,
              onTap: () => onChanged(0),
            ),
          ),

          Expanded(
            child: _TabButton(
              text: "Friends",
              selected: currentIndex == 1,
              onTap: () => onChanged(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {

  final String text;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.text,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    return InkWell(

      borderRadius: BorderRadius.circular(14),

      onTap: onTap,

      child: AnimatedContainer(

        duration: const Duration(milliseconds: 200),

        decoration: BoxDecoration(
          color: selected
              ? AppColor.primary
              : Colors.transparent,

          borderRadius: BorderRadius.circular(14),
        ),

        alignment: Alignment.center,

        child: Text(
          text,
          style: TextStyle(
            color: selected
                ? Colors.white
                : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}