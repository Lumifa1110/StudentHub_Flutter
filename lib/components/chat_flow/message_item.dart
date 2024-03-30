import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/index.dart';

class MessageItem extends StatelessWidget {
  final MessageModel message;
  final bool isMyMessage;

  const MessageItem(
      {super.key, required this.message, required this.isMyMessage});

  Widget buildTimestamp(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      color: Colors.transparent,
      child: Text(
        DateFormat.Hm().format(message.time),
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (isMyMessage) 
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerRight,
              child: buildTimestamp(context)
            ),
          ),
        Flexible(
          flex: 2,
          fit: FlexFit.loose,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * (2 / 3),
            ),
            decoration: BoxDecoration(
              color: isMyMessage ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(8.0),
            ),
            padding: const EdgeInsets.all(16.0),
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              message.content,
              style: TextStyle(fontSize: 16.0, color: isMyMessage ? Colors.white : Colors.black),
            ),
          ),
        ),
        if (!isMyMessage) 
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: buildTimestamp(context)
            ),
          ),
      ],
    );
  }
}
