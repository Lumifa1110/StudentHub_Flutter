import 'package:flutter/material.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final VoidCallback onChange;

  const CustomSearchBar({super.key, required this.controller, required this.placeholder, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2, bottom: 2, left: 16, right: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(21),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (value) {
                onChange();
              },
              cursorColor: AppColor.primary,
              style: const TextStyle(fontSize: AppFonts.h3FontSize),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle:
                    TextStyle(fontSize: AppFonts.h3FontSize, color: Theme.of(context).colorScheme.onSurface),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () {
              // Handle search button pressed
            },
          ),
        ],
      ),
    );
  }
}
