import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:studenthub/components/bottomsheet_schedule.dart';
import 'package:studenthub/components/chat_flow/interview_control_dialog.dart';
import 'package:studenthub/components/index.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class InterviewItem extends StatefulWidget {
  final Interview interview;
  final Function(int, String, DateTime, DateTime)? handleEditInterview;
  final Function(int)? handleDeleteInterview;

  const InterviewItem(
      {super.key,
      required this.interview,
      this.handleEditInterview,
      this.handleDeleteInterview});

  @override
  State<InterviewItem> createState() => _InterviewItemState();
}

class _InterviewItemState extends State<InterviewItem> {
  bool isHidden = false;

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

  bool isInterviewOccurring() {
    DateTime currentTime = DateTime.now();
    DateTime startTime = widget.interview.startTime;
    DateTime endTime = widget.interview.endTime;
    Duration tolerance = const Duration(seconds: 1);
    return currentTime.isAfter(startTime.subtract(tolerance)) &&
        currentTime.isBefore(endTime.add(tolerance));
  }

  void handleEditAndUpdateState(
      int interviewId, String title, DateTime startTime, DateTime endTime) {
    widget.handleEditInterview!(interviewId, title, startTime, endTime);
    setHidden();
  }

  void setHidden() {
    setState(() {
      isHidden = true;
    });
  }

  void handleDeleteAndUpdateState(int interviewId) {
    widget.handleDeleteInterview!(interviewId);
    setHidden();
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      if (isHidden == false)
        Expanded(
            flex: 1,
            child: Container(
                margin: const EdgeInsets.only(top: 30, bottom: 30),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    border: Border.all(color: Theme.of(context).colorScheme.onSurface),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.shadow.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 2,
                      ),
                    ]),
                child: Column(children: [
                  Row(children: [
                    Expanded(
                        flex: 3,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text('Scheduled Interview',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: AppFonts.h4FontSize,
                                    fontWeight: FontWeight.w500)))),
                    Expanded(
                        flex: 4,
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                                calculateDuration(widget.interview.startTime,
                                    widget.interview.endTime),
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontSize: AppFonts.h4FontSize,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.italic))))
                  ]),
                  Row(children: [
                    Expanded(
                        flex: 1,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(widget.interview.title,
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontSize: AppFonts.h2FontSize,
                                    fontWeight: FontWeight.w500))))
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
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      fontSize: AppFonts.h5FontSize,
                                      fontWeight: FontWeight.w400)),
                              Text(formatDateTime(widget.interview.startTime),
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
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
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                      fontSize: AppFonts.h5FontSize,
                                      fontWeight: FontWeight.w400)),
                              Text(formatDateTime(widget.interview.endTime),
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface,
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
                    const SizedBox(width: 10),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            Theme.of(context).colorScheme.surface,
                      ),
                      child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogEditInterview(
                                editInterviewCallback: () {
                                  showModalBottomSheet(
                                    context: context,
                                    barrierColor: Colors.black.withAlpha(1),
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(0)),
                                    ),
                                    builder: (BuildContext context) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: lightestgrayColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color: blackTextColor
                                                  .withOpacity(0.5),
                                              spreadRadius: 6,
                                              blurRadius: 9,
                                              offset: const Offset(0, 1),
                                            ),
                                          ],
                                        ),
                                        child: SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                5 /
                                                9,
                                            child: BottomSheetSchedule(
                                                interviewId:
                                                    widget.interview.id,
                                                title: widget.interview.title,
                                                startDate:
                                                    widget.interview.startTime,
                                                endDate:
                                                    widget.interview.endTime,
                                                enableEdit: true,
                                                handleEditInterview:
                                                    handleEditAndUpdateState)),
                                      );
                                    },
                                  );
                                },
                                deleteInterviewCallback: () {
                                  handleDeleteAndUpdateState(
                                      widget.interview.id!);
                                },
                              );
                            },
                          );
                        },
                        icon: Icon(
                          Icons.more_horiz,
                          color: Theme.of(context).colorScheme.onSurface, // Adjust the color as needed
                        ),
                        iconSize: 24, // Adjust the icon size as needed
                      ),
                    )
                  ])
                ])))
      else
        const SizedBox.shrink()
    ]);
  }
}
