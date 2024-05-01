import 'package:flutter/material.dart';
import 'package:studenthub/components/user/user_avatar.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/screens/chat_flow/message_detail_screen.dart';
import 'package:studenthub/services/index.dart';
import 'package:studenthub/utils/font.dart';

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

class ConversationItem extends StatefulWidget {
  final Message message;
  final int messageCount;

  const ConversationItem(
      {super.key, required this.message, required this.messageCount});

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
          padding:
              const EdgeInsets.only(top: 6, bottom: 6, left: 12, right: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 2,
              )
            ],
          ),
          child: Row(children: [
            // Sender avatar
            Expanded(
                flex: 1,
                child: Container(
                    alignment: Alignment.centerLeft,
                    child: const UserAvatar(icon: Icons.person))),
            const SizedBox(width: 12),
            // Sender name + Message snapshot
            Expanded(
                flex: 6,
                child: Container(
                  padding: const EdgeInsets.only(left: 0),
                  height: 60,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Expanded(
                            flex: 4,
                            child: Text(
                                widget.message.sender.id == userId
                                    ? widget.message.receiver.fullname
                                    : widget.message.sender.fullname,
                                style: const TextStyle(
                                    color: AppFonts.primaryColor,
                                    fontSize: AppFonts.h3FontSize,
                                    fontWeight: FontWeight.w500)),
                          ),
                          Expanded(
                            flex: 2,
                            child: Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                  formatTimeAgo(widget.message.createdAt),
                                  style: const TextStyle(
                                      color: AppFonts.tertiaryColor,
                                      fontSize: AppFonts.h5FontSize,
                                      fontWeight: FontWeight.w400)),
                            ),
                          )
                        ]),
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
          ])),
    );
  }
}
