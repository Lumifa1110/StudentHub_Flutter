import 'package:flutter/material.dart';
import 'package:studenthub/components/index.dart';

class DialogEditInterview extends StatelessWidget {
  final Function editInterviewCallback;
  final Function deleteInterviewCallback;

  const DialogEditInterview(
      {super.key,
      required this.editInterviewCallback,
      required this.deleteInterviewCallback});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(bottom: 30),
        child: Dialog(
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ButtonSimple(
                  label: 'Edit Interview',
                  onPressed: () {
                    Navigator.pop(context);
                    editInterviewCallback();
                  },
                  isButtonEnabled: true,
                ),
                ButtonSimple(
                  label: 'Delete Interview',
                  onPressed: () {
                    deleteInterviewCallback();
                    Navigator.pop(context);
                  },
                  isButtonEnabled: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
