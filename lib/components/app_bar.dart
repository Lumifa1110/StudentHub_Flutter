import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class MyAppBar extends StatelessWidget {
  final String title;

  const MyAppBar({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(left: 10),
        child: const FaIcon(
          FontAwesomeIcons.chevronLeft,
          color: Colors.white,
          size: 18
        )
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: AppFonts.h1FontSize,
          fontWeight: FontWeight.w500
        )
      ),
      //centerTitle: true,
      actions: [
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(right: 20),
          child: const FaIcon(
            FontAwesomeIcons.solidUser,
            color: Color(0xffffffff),
            size: 24
          ),
        )
      ],
      backgroundColor: mainColor,
    );
  }
}