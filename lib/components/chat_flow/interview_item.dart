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

  bool isInterviewOccuring() {
    DateTime currentTime = DateTime.now();
    if (currentTime.isAfter(widget.interview.startTime) &&
        currentTime.isBefore(widget.interview.endTime)) {
      return true;
    } else {
      return false;
    }
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
                        flex: 3,
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: const Text('Scheduled Interview',
                                style: TextStyle(
                                    color: AppColor.primary,
                                    fontSize: AppFonts.h4FontSize,
                                    fontWeight: FontWeight.w500)))),
                    Expanded(
                        flex: 4,
                        child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                                calculateDuration(widget.interview.startTime,
                                    widget.interview.endTime),
                                style: const TextStyle(
                                    color: AppFonts.primaryColor,
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
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => InterviewScreen(
                                              conferenceId: widget
                                                  .interview
                                                  .meetingRoom!
                                                  .meetingRoomId)));
                                },
                                // isButtonEnabled:
                                //     (isInterviewOccuring() && widget.interview.disableFlag == false) ? true : false,
                                isButtonEnabled: true))),
                    const SizedBox(width: 10),
                    Container(
                      width: 40, // Adjust the width as needed
                      height: 40, // Adjust the height as needed
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            Colors.black38, // Adjust the button color as needed
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
                        icon: const Icon(
                          Icons.more_horiz,
                          color: Colors.white, // Adjust the color as needed
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
