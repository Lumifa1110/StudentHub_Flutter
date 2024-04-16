import 'package:flutter/material.dart';
import 'package:studenthub/utils/font.dart';

class ListEmptyBox extends StatelessWidget {
  const ListEmptyBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.center,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(8)
            ),
            child: const Text(
              'empty',
              style: TextStyle(
                color: Colors.black38,
                fontSize: AppFonts.h3FontSize,
                fontWeight: FontWeight.w400
              )
            ),
          ),
        ),
      ]
    );
  }
}