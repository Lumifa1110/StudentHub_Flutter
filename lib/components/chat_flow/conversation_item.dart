import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:studenthub/components/user/user_avatar.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/screens/chat_flow/message_detail_screen.dart';
import 'package:studenthub/services/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class ConversationItem extends StatefulWidget {
  final Message message;
  final int messageCount;

  const ConversationItem({super.key, required this.message, required this.messageCount});

  @override
  State<ConversationItem> createState() => _ConversationItemState();
}

class _ConversationItemState extends State<ConversationItem> {
  late int userId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    userId = 0;
    loadUserId();
  }

  Future<void> loadUserId() async {
    final response = await AuthService.getUserInfo();
    if (mounted) {
      setState(() {
        userId = response['result']['id'];
        _isLoading = false;
      });
    }
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
              chatter: widget.message.sender!.id == userId
                  ? widget.message.receiver!
                  : widget.message.sender!,
            ),
          ),
        );
        // print(widget.message.project!.projectId);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(top: 6, bottom: 6, left: 12, right: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.3),
              spreadRadius: 3.0,
              blurRadius: 3.0,
            ),
          ],
        ),
        child: _isLoading ? _buildLoadingItem() : _buildConversationItem(),
      ),
    );
  }

  Widget _buildLoadingItem() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.centerLeft,
            child: _isLoading ? const UserAvatar(icon: Icons.person) : Container(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 6,
          child: Container(
            padding: const EdgeInsets.only(left: 0),
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 16,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: lightergrayColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  height: 16,
                  width: MediaQuery.of(context).size.width * 0.8,
                  decoration: BoxDecoration(
                    color: lightergrayColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                      child: Container(color: Colors.transparent),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConversationItem() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            alignment: Alignment.centerLeft,
            child: UserAvatar(
              icon: Icons.person,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 6,
          child: Container(
            padding: const EdgeInsets.only(left: 0),
            height: 60,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        widget.message.sender!.id == userId
                            ? widget.message.receiver!.fullname
                            : widget.message.sender!.fullname,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: AppFonts.h2FontSize,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          formatTimeAgo(widget.message.createdAt),
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
                            fontSize: AppFonts.h5FontSize,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Flexible(
                  child: Text(
                    widget.message.content,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: AppFonts.h3FontSize,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
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
