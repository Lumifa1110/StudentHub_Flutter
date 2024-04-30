import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/user/user_avatar.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/screens/chat_flow/message_detail_screen.dart';
import 'package:studenthub/services/index.dart';
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

class ConversationItem extends StatefulWidget {
  final Message message;
  final int messageCount;

  const ConversationItem({super.key, required this.message, required this.messageCount});

  @override
  State<ConversationItem> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  late int userId;

  @override
  void initState() {
    super.initState();
    userId = 0;
    loadUserId();
  }

  Future<void> loadUserId() async {
    final response = await AuthService.getUserInfo();
    setState(() {
      userId = response['result']['id'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MessageDetailScreen(
                projectId: widget.message.project!.projectId,
                chatter: widget.message.sender.id == userId
                    ? widget.message.receiver
                    : widget.message.sender),
          ),
        );
      },
      child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.only(top: 6, bottom: 6, left: 6, right: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE9E9E9),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 1,
                  offset: const Offset(0, 1))
            ],
          ),
          child: Row(children: [
            // Sender avatar
            const Expanded(
                flex: 1,
                child: UserAvatar(
                  icon: Icons.person,
                )),
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
                            widget.message.sender.id == userId
                                ? widget.message.receiver.fullname
                                : widget.message.sender.fullname,
                            style: const TextStyle(
                                color: AppFonts.primaryColor,
                                fontSize: AppFonts.h3FontSize,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        Flexible(
                          child: Text(
                            widget.message.content,
                            style: const TextStyle(
                                color: AppFonts.secondaryColor,
                                fontSize: AppFonts.h4FontSize,
                                fontWeight: FontWeight.w400),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ]),
                )),
            Expanded(
                flex: 1,
                child: SizedBox(
                  height: 50,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColor.primary,
                          ),
                          child: Center(
                            child: Text(
                              widget.messageCount.toString(),
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
                          formatTimeAgo(widget.message.createdAt),
                          style: const TextStyle(
                              color: AppFonts.secondaryColor,
                              fontSize: AppFonts.h4FontSize,
                              fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ]),
                )),
          ])),
    );
  }
}
