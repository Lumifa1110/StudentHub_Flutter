import 'package:flutter/material.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class TabBarItem extends StatelessWidget {
  final bool isActive;
  final String title;

  const TabBarItem({
    super.key,
    required this.isActive,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 100,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? AppColor.primary : Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.withAlpha(140), width: 1)
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : AppFonts.primaryColor,
          fontSize: AppFonts.h3FontSize,
          fontWeight: FontWeight.w500
        )
      )
    );
  }
}