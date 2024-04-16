import 'package:flutter/material.dart';
import 'package:studenthub/utils/font.dart';

class CustomTextarea extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int maxLines;

  const CustomTextarea({
    super.key,
    required this.controller,
    this.hintText,
    required this.maxLines
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: 36.0 + 24.0 * maxLines,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(8)
            ),
            // Textfield
            child: Container(
              alignment: Alignment.topLeft,
              child: TextField(
                controller: controller,
                maxLines: maxLines,
                style: const TextStyle(
                  color: AppFonts.primaryColor,
                  fontSize: AppFonts.h3FontSize
                ),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: Colors.black26
                  ),
                  border: InputBorder.none
                ),
              ),
            ),
          )
        )
      ]
    );
  }
}