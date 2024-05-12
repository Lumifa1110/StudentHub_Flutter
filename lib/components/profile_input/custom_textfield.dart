import 'package:flutter/material.dart';
import 'package:studenthub/utils/font.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;

  const CustomTextfield({
    super.key,
    required this.controller,
    this.hintText
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black26),
              borderRadius: BorderRadius.circular(8)
            ),
            // Textfield
            child: Center(
              child: TextField(
                controller: controller,
                maxLines: 1,
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