import 'package:flutter/material.dart';

class TextFieldWithLabel extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final double lineCount;

  const TextFieldWithLabel({
    super.key,
    required this.label,
    required this.controller,
    required this.lineCount
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
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: Colors.grey,
              width: 1
            )
          ),
          child: Container(
            height: 40 * lineCount,
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              controller: controller,
              textAlign: TextAlign.left,
              maxLines: null,
              style: const TextStyle(
                fontSize: 14,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero
              ),
            )
          ),
        )
      ]
    );
  }
}