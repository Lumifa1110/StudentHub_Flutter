import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/enums/index.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/screens/student/view_candidate_sceen.dart';
import 'package:studenthub/services/index.dart';
import 'package:studenthub/utils/font.dart';

import '../../screens/chat_flow/message_detail_screen.dart';
import '../../screens/student/view_offer_screen.dart';

class NotificationItem extends StatefulWidget {
  final NotificationModel notification;
  final int? userId;

  const NotificationItem({super.key, required this.notification, this.userId});

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    IconData typeNotifyIcon;
    String typeNotifyLabel = "";
    String notificationContent = "";

    switch (widget.notification.typeNotifyFlag) {
      case TypeNotifyFlag.offer:
        typeNotifyIcon = FontAwesomeIcons.envelopeOpenText;
        typeNotifyLabel = "Offer";
        notificationContent =
            "${widget.notification.sender!.fullname} sent you a job offer";
        break;
      case TypeNotifyFlag.interview:
        typeNotifyIcon = FontAwesomeIcons.video;
        typeNotifyLabel = "Interview";
        notificationContent =
            "${widget.notification.sender!.fullname} scheduled an interview";
        break;
      case TypeNotifyFlag.submitted:
        typeNotifyIcon = FontAwesomeIcons.fileContract;
        typeNotifyLabel = "Proposal";
        notificationContent = widget.notification.content;
        break;
      case TypeNotifyFlag.chat:
        typeNotifyIcon = FontAwesomeIcons.message;
        typeNotifyLabel = "Message";
        notificationContent =
            "${widget.notification.sender!.fullname}: ${widget.notification.message!.content}";
        break;
      case TypeNotifyFlag.hired:
        typeNotifyIcon = FontAwesomeIcons.briefcase;
        typeNotifyLabel = "Hired";
        notificationContent =
            widget.notification.content.replaceAll("sent you a message", '');
        break;
      default:
        typeNotifyIcon = FontAwesomeIcons.question;
        typeNotifyLabel = "Unknown";
    }

    return GestureDetector(
      onTap: () async {
        switch (widget.notification.typeNotifyFlag) {
          case TypeNotifyFlag.offer:
            Navigator.push(context, MaterialPageRoute(builder: (context) => ViewOfferScreen(notification: widget.notification)));
           // print( widget.notification.message!.project);
            break;
          case TypeNotifyFlag.interview:
            {
              if (mounted) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessageDetailScreen(
                        projectId: widget.notification.message!.projectId!,
                        chatter: widget.notification.message!.senderId ==
                                widget.userId
                            ? widget.notification.receiver!
                            : widget.notification.sender!,
                      ),
                    ));
              }
              break;
            }
          case TypeNotifyFlag.submitted:
            {
              final proposalData = await ProposalService.getProjectByCompanyId(
                  widget.notification.proposalId!);
              if (mounted) {
                Navigator.push(
                  // ignore: use_build_context_synchronously
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewCandidateSceen(
                      candidateId: widget.notification.proposalId,
                      candidateData: proposalData['result'],
                    ),
                  ),
                );
              }
              break;
            }
          case TypeNotifyFlag.chat:
            {
              if (mounted) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MessageDetailScreen(
                        projectId: widget.notification.message!.projectId!,
                        chatter: widget.notification.message!.senderId ==
                                widget.userId
                            ? widget.notification.receiver!
                            : widget.notification.sender!,
                      ),
                    ));
              }
              break;
            }
          case TypeNotifyFlag.hired:
            {
              break;
            }
          default:
        }
      },
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    border: Border(
                      bottom: BorderSide(color: Theme.of(context).colorScheme.shadow),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: FaIcon(typeNotifyIcon, size: 24)),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                          flex: 7,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Text(typeNotifyLabel,
                                        style: TextStyle(
                                            color: Theme.of(context).colorScheme.onSurface,
                                            fontSize: AppFonts.h3FontSize,
                                            fontWeight: FontWeight.w900)),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          formatTimeAgo(
                                              widget.notification.createdAt!),
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.onSurface,
                                            fontSize: AppFonts.h4FontSize,
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(notificationContent,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  color:
                                                      Theme.of(context).colorScheme.onSurface,
                                                  fontSize: AppFonts.h4FontSize,
                                                  fontWeight: FontWeight.w400))
                                        ],
                                      ))
                                ],
                              )
                            ],
                          ))
                    ],
                  )))
        ],
      ),
    );
  }
}

String formatTimeAgo(DateTime time) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(time);

  if (difference.inSeconds < 60) {
    return '1 min ago';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} min ago';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
  } else {
    return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
  }
}
