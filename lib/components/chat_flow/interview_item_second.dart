import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/utils/font.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/components/index.dart';

class InterviewItemSecondary extends StatefulWidget {
  final Interview interview;

  const InterviewItemSecondary({
    super.key,
    required this.interview,
  });

  @override
  State<InterviewItemSecondary> createState() => _InterviewItemState();
}

class _InterviewItemState extends State<InterviewItemSecondary> {
  @override
  void initState() {
    super.initState();
  }

  String formatDateTime(DateTime dateTime) {
    final formatter = DateFormat('EEEE d/M/yyyy HH:mm');
    return formatter.format(dateTime);
  }

  String calculateDuration(DateTime startTime, DateTime endTime) {
    Duration difference = endTime.difference(startTime);
    int hours = difference.inHours;
    int minutes = difference.inMinutes.remainder(60);
    if (hours > 0 && minutes > 0) {
      return '$hours hour${hours > 1 ? 's' : ''} $minutes minute${minutes > 1 ? 's' : ''}';
    } else if (hours > 0) {
      return '$hours hour${hours > 1 ? 's' : ''}';
    } else {
      return '$minutes minute${minutes > 1 ? 's' : ''}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 1,
          child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    ),
                  ]),
              child: Column(children: [
                Row(children: [
                  Expanded(
                      flex: 2,
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(widget.interview.title,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: AppFonts.h2FontSize,
                                  fontWeight: FontWeight.w500)))),
                  Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: Text(
                              calculateDuration(widget.interview.startTime,
                                  widget.interview.endTime),
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontSize: AppFonts.h4FontSize,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.italic))))
                ]),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                      flex: 1,
                      child: FaIcon(
                        FontAwesomeIcons.clock,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 26,
                      )),
                  const SizedBox(width: 6),
                  Expanded(
                      flex: 8,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Start Time',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    fontSize: AppFonts.h5FontSize,
                                    fontWeight: FontWeight.w400)),
                            Text(formatDateTime(widget.interview.startTime),
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    fontSize: AppFonts.h3FontSize,
                                    fontWeight: FontWeight.w500)),
                          ]))
                ]),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                      flex: 1,
                      child: FaIcon(
                        FontAwesomeIcons.clock,
                        color: Theme.of(context).colorScheme.onSurface,
                        size: 26,
                      )),
                  const SizedBox(width: 6),
                  Expanded(
                      flex: 8,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('End Time',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                    fontSize: AppFonts.h5FontSize,
                                    fontWeight: FontWeight.w400)),
                            Text(formatDateTime(widget.interview.endTime),
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontSize: AppFonts.h3FontSize,
                                    fontWeight: FontWeight.w500)),
                          ]))
                ]),
                Row(children: [
                  Expanded(
                      flex: 1,
                      child: Container(
                          alignment: Alignment.centerRight,
                          child: ButtonSimple(
                            label: 'Join',
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => InterviewScreen(
                                          conferenceId: widget.interview
                                              .meetingRoom!.meetingRoomId)));
                            },
                            isButtonEnabled: true,
                          ))),
                ])
              ])))
    ]);
  }
}
