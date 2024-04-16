import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/utils/font.dart';

class PickedFileItem extends StatelessWidget {
  final String filename;

  const PickedFileItem({
    super.key,
    required this.filename
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Container(
          height: 50,
          margin: const EdgeInsets.only(top: 10, bottom: 20),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 2,
                spreadRadius: 2,
                offset: Offset(0, 1)
              )
            ]
          ),
          child: Row(children: [
            const Expanded(
              flex: 1,
              child: FaIcon(
                FontAwesomeIcons.file,
                size: 30
              )
            ),
            Expanded(
              flex: 8,
              child: Container(
                height: 40,
                alignment: Alignment.centerLeft,
                child: Text(
                  filename,
                  style: const TextStyle(
                    color: AppFonts.primaryColor,
                    fontSize: AppFonts.h4FontSize,
                    fontWeight: FontWeight.w500
                  )
                )
              ),
            ),
            const Expanded(
              flex: 1,
              child: FaIcon(
                FontAwesomeIcons.check,
                size: 20,
                color: Colors.green
              )
            ),
          ],)
        )
      )
    ],);
  }
}