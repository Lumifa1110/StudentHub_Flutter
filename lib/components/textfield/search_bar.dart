import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class ChatSearchBar extends StatelessWidget {
  final String placeholder;

  const ChatSearchBar({
    super.key,
    required this.placeholder
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 4),
      decoration: BoxDecoration(
        color: Colors.white, // Change to your desired background color
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2), // Shadow color
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 2), // Changes the position of the shadow
          ),
        ]
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
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