import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/enums/index.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

import '../../screens/chat_flow/message_detail_screen.dart';
import '../../services/auth_service.dart';

class NotificationItem extends StatefulWidget {
  final NotificationModel notification;
  final int ?userId;

  const NotificationItem({super.key, required this.notification, this.userId});

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  // @override
  // void initState() {
  //   super.initState();
  //   userId = 0;
  //   loadUserId();
  // }
  // Future<void> loadUserId() async {
  //   final response = await AuthService.getUserInfo();
  //   if (mounted) {
  //     setState(() {
  //       userId = response['result']['id'];
  //     });
  //   }
  // }
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
            "${widget.notification.sender!.fullname} sent you a message";
        break;
      case TypeNotifyFlag.interview:
        typeNotifyIcon = FontAwesomeIcons.video;
        typeNotifyLabel = "Interview";
        notificationContent =
            "${widget.notification.sender!.fullname} scheduled an interview";
        break;
      case TypeNotifyFlag.submitted:
        typeNotifyIcon = FontAwesomeIcons.check;
        typeNotifyLabel = "Proposal";
        notificationContent =
            "${widget.notification.sender!.fullname} sent you a message";
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
            "${widget.notification.sender!.fullname} sent you a message";
        break;
      default:
        typeNotifyIcon = FontAwesomeIcons.question;
        typeNotifyLabel = "Unknown";
    }

    return GestureDetector(
      onTap: () async{
        switch (widget.notification.typeNotifyFlag) {
          case TypeNotifyFlag.offer:
            Navigator.pushNamed(context, '/offer/view');
           // print( widget.notification.message!.project);
            break;
          case TypeNotifyFlag.interview:
            print('interview');
            break;
          case TypeNotifyFlag.submitted:
            print('submitted');
            break;
          case TypeNotifyFlag.chat:
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => MessageDetailScreen(
                projectId: widget.notification.message!.projectId!,
                chatter: widget.notification.message!.senderId == widget.userId
                    ? widget.notification.receiver!
                    : widget.notification.sender!,
              ),
            ));
            // SharedPreferences _prefs = await SharedPreferences.getInstance();
            // print(widget.userId);
            // print(widget.notification.sender);



            break;
          case TypeNotifyFlag.hired:
            print('hired');

            break;
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
                  decoration: const BoxDecoration(
                    color: AppColor.background,
                    border: Border(
                      bottom: BorderSide(color: Colors.black12),
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
                                        style: const TextStyle(
                                            color: AppFonts.primaryColor,
                                            fontSize: AppFonts.h3FontSize,
                                            fontWeight: FontWeight.w900)),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(formatTimeAgo(widget.notification.createdAt!),
                                          style: const TextStyle(
                                              color: AppFonts.secondaryColor,
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
                                      child: Text(notificationContent,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: const TextStyle(
                                              color: AppFonts.secondaryColor,
                                              fontSize: AppFonts.h3FontSize,
                                              fontWeight: FontWeight.w400)))
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
