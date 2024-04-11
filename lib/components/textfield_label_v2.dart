import 'package:flutter/material.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class TextFieldWithLabel2 extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;

  const TextFieldWithLabel2({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: AppFonts.h3FontSize,
              fontWeight: FontWeight.w500,
              color: blackTextColor,
            ),
          ),
        ),
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: whiteTextColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: blackTextColor, width: 1),
          ),
          child: Center(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        )
      ],
    );
  }
}
