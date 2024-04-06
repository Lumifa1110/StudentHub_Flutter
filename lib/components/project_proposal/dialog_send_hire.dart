import 'package:flutter/material.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class DialogSendHire extends StatelessWidget {
  final VoidCallback sendHireOffer;

  const DialogSendHire({
    super.key,
    required this.sendHireOffer
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      insetPadding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      title: const Text(
        'Hire offer',
        style: TextStyle(
          color: AppColor.primary,
          fontSize: AppFonts.h2FontSize,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Do you want to send hire offer for student to do this project?',
            style: TextStyle(
              color: AppFonts.primaryColor,
              fontSize: AppFonts.h3FontSize
            ),
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
                sendHireOffer();
                Navigator.pop(context);
              },
              child: const Align(
                alignment: Alignment.centerRight,
                child: Text('Send'),
              ),
            ),
          ],
        )
      ],
    );
  }
}