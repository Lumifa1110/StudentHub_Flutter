import 'package:flutter/material.dart';
import 'package:studenthub/models/language_model.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class LanguageItem extends StatelessWidget {
  final Language language;
  final VoidCallback handleDelete;
  final bool hideDelete;

  const LanguageItem({
    super.key,
    required this.language,
    required this.handleDelete,
    this.hideDelete = false,
  });

  Color languageLevelColor() {
    switch (language.level) {
      case 'Low':
        return const Color.fromARGB(255, 207, 49, 38);
      case 'Medium':
        return const Color.fromARGB(255, 212, 192, 12);
      case 'High':
        return const Color.fromARGB(255, 71, 192, 75);
      case 'Expert':
        return AppColor.primary;
      default:
        return AppFonts.primaryColor; // Default color if not 'Low' or 'High'
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.white, languageLevelColor()],
              stops: const [0.6, 0.75],
            ),
            border: Border.all(color: AppFonts.primaryColor.withOpacity(0.1)),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 1, spreadRadius: 1, offset: Offset(0, 1))
            ],
            borderRadius: BorderRadius.circular(6)),
        child: Row(children: [
          Expanded(
              flex: 7,
              child: Text(
                  textAlign: TextAlign.left,
                  language.languageName,
                  style: const TextStyle(
                      color: AppFonts.primaryColor,
                      fontSize: AppFonts.h3FontSize,
                      fontWeight: FontWeight.w500))),
          Expanded(
              flex: 3,
              child: Text(
                  textAlign: TextAlign.right,
                  language.level,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: AppFonts.h3FontSize,
                      fontWeight: FontWeight.w500))),
          hideDelete
              ? SizedBox()
              : Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      handleDelete();
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: const Icon(Icons.clear, size: AppFonts.h2FontSize),
                    ),
                  )),
        ]));
  }
}
