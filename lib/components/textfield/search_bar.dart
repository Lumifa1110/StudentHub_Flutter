import 'package:flutter/material.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;

  const CustomSearchBar({
    super.key,
    required this.controller,
    required this.placeholder
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.only(top: 2, bottom: 2, left: 16, right: 4),
      decoration: BoxDecoration(
        color: AppColor.textFieldBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              cursorColor: AppColor.primary,
              style: const TextStyle(
                fontSize: AppFonts.h3FontSize
              ),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: const TextStyle( 
                  fontSize: AppFonts.h3FontSize
                ),
                
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Handle search button pressed
            },
          ),
        ],
      ),
    );
  }
}