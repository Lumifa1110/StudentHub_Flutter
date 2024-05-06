import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/enums/index.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class NotificationItem extends StatelessWidget {
  final NotificationModel notification;

  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    IconData typeNotifyIcon;
    String typeNotifyLabel = "";
    String notificationContent = "";

    switch (notification.typeNotifyFlag) {
      case TypeNotifyFlag.offer:
        typeNotifyIcon = FontAwesomeIcons.envelopeOpenText;
        typeNotifyLabel = "Offer";
        notificationContent =
            "${notification.sender!.fullname} sent you a message";
        break;
      case TypeNotifyFlag.interview:
        typeNotifyIcon = FontAwesomeIcons.video;
        typeNotifyLabel = "Interview";
        notificationContent =
            "${notification.sender!.fullname} scheduled an interview";
        break;
      case TypeNotifyFlag.submitted:
        typeNotifyIcon = FontAwesomeIcons.check;
        typeNotifyLabel = "Proposal";
        notificationContent =
            "${notification.sender!.fullname} sent you a message";
        break;
      case TypeNotifyFlag.chat:
        typeNotifyIcon = FontAwesomeIcons.message;
        typeNotifyLabel = "Message";
        notificationContent =
            "${notification.sender!.fullname}: ${notification.message!.content}";
        break;
      default:
        typeNotifyIcon = FontAwesomeIcons.question;
        typeNotifyLabel = "Unknown";
    }

    return Row(
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
                                    child: Text(formatTimeAgo(notification.createdAt!),
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
