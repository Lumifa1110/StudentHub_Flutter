import 'package:flutter/material.dart';
import 'package:studenthub/components/user/user_avatar.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

String formatTimeAgo(DateTime time) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(time);

  if (difference.inSeconds < 60) {
    return '1m';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes}m';
  } else if (difference.inHours < 24) {
    return '${difference.inHours}h';
  } else {
    return '${difference.inDays}d';
  }
}

class ConversationItem extends StatelessWidget {
  final MessageModel message;
  final int messageCount;

  const ConversationItem({
    super.key,
    required this.message,
    required this.messageCount
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.only(top: 6, bottom: 6, left: 4, right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 2)
          )
        ]
      ),
      child: Row(
        children: [
          // Send avatar
          const Expanded(
            flex: 1,
            child: UserAvatar(icon: Icons.person,)
          ),
          const SizedBox(width: 6),
          // Sender name + Message snapshot
          Expanded(
            flex: 5,
            child: Container(
              padding: const EdgeInsets.only(left: 0),
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.sender,
                    style: const TextStyle(
                      color: AppFonts.primaryColor,
                      fontSize: AppFonts.h3FontSize,
                      fontWeight: FontWeight.w600
                    )
                  ),
                  const SizedBox(height: 4),
                  Flexible(
                    child: Text(
                      message.content,
                      style: const TextStyle(
                        color: AppFonts.secondaryColor,
                        fontSize: AppFonts.h4FontSize,
                        fontWeight: FontWeight.w400
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ]
              ),
            )
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.only(left: 0),
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColor.primary,
                    ),
                    child: Center(
                      child: Text(
                        messageCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppFonts.h4FontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatTimeAgo(message.time),
                    style: const TextStyle(
                      color: AppFonts.secondaryColor,
                      fontSize: AppFonts.h4FontSize,
                      fontWeight: FontWeight.w400
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ]
              ),
            )
          ),
        ]
      )
    );
  }
}