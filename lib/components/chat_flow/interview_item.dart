import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:studenthub/components/index.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class InterviewItem extends StatefulWidget {
  final Interview interview;

  const InterviewItem({super.key, required this.interview});

  @override
  State<InterviewItem> createState() => _InterviewItemState();
}

class _InterviewItemState extends State<InterviewItem> {
  String formatDateTime(DateTime dateTime) {
    // Define the format pattern
    final formatter = DateFormat('EEEE d/M/yyyy HH:mm');
    // Format the DateTime object using the formatter
    return formatter.format(dateTime);
  }

  bool isInterviewOccuring() {
    DateTime currentTime = DateTime.now();
    if (currentTime.isAfter(widget.interview.startTime) &&
        currentTime.isBefore(widget.interview.endTime)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 1,
          child: Container(
              margin: const EdgeInsets.only(top: 30, bottom: 30),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 2,
                    ),
                  ]),
              child: Column(children: [
                Row(children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: const Text('Scheduled Interview',
                              style: TextStyle(
                                  color: AppColor.primary,
                                  fontSize: AppFonts.h4FontSize,
                                  fontWeight: FontWeight.w500))))
                ]),
                Row(children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(widget.interview.title,
                              style: const TextStyle(
                                  color: AppFonts.primaryColor,
                                  fontSize: AppFonts.h2FontSize,
                                  fontWeight: FontWeight.w500))))
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  const Expanded(
                      flex: 1,
                      child: FaIcon(
                        FontAwesomeIcons.clock,
                        color: AppFonts.primaryColor,
                        size: 26,
                      )),
                  const SizedBox(width: 6),
                  Expanded(
                      flex: 8,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Start Time',
                                style: TextStyle(
                                    color: AppFonts.secondaryColor,
                                    fontSize: AppFonts.h5FontSize,
                                    fontWeight: FontWeight.w400)),
                            Text(formatDateTime(widget.interview.startTime),
                                style: const TextStyle(
                                    color: AppFonts.primaryColor,
                                    fontSize: AppFonts.h3FontSize,
                                    fontWeight: FontWeight.w500)),
                          ]))
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  const Expanded(
                      flex: 1,
                      child: FaIcon(
                        FontAwesomeIcons.clock,
                        color: AppFonts.primaryColor,
                        size: 26,
                      )),
                  const SizedBox(width: 6),
                  Expanded(
                      flex: 8,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('End Time',
                                style: TextStyle(
                                    color: AppFonts.secondaryColor,
                                    fontSize: AppFonts.h5FontSize,
                                    fontWeight: FontWeight.w400)),
                            Text(formatDateTime(widget.interview.endTime),
                                style: const TextStyle(
                                    color: AppFonts.primaryColor,
                                    fontSize: AppFonts.h3FontSize,
                                    fontWeight: FontWeight.w500)),
                          ]))
                ]),
                const SizedBox(height: 6),
                Row(children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: ButtonSimple(
                            label: 'Join',
                            onPressed: () {},
                            isButtonEnabled:
                                isInterviewOccuring() ? true : false,
                          )))
                ])
              ])))
    ]);
  }
}
