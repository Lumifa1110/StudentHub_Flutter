import 'package:flutter/material.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class DialogAlert extends StatelessWidget {
  final Future<void> Function(dynamic idProject, {int currentTab}) fFunction;
  final String titleDialog;
  final dynamic project;
  final String question;
  final String textAcceptButton;
  final int currentTab;

  const DialogAlert(
      {super.key,
      required this.fFunction,
      required this.titleDialog,
      this.project,
      required this.question,
      required this.textAcceptButton,
      required this.currentTab});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      insetPadding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      title: Text(
        titleDialog,
        style: const TextStyle(
          color: AppColor.primary,
          fontSize: AppFonts.h2FontSize,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            question,
            style: const TextStyle(color: AppFonts.primaryColor, fontSize: AppFonts.h3FontSize),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      actions: <Widget>[
        ButtonBar(
          alignment: MainAxisAlignment.spaceBetween,
          buttonPadding: EdgeInsets.zero,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text('Cancel'),
              ),
            ),
            TextButton(
              onPressed: () {
                fFunction(project, currentTab: currentTab);
                Navigator.pop(context);
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(textAcceptButton),
              ),
            ),
          ],
        )
      ],
    );
  }
}
