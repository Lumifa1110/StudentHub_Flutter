import 'package:studenthub/models/index.dart';

class Message {
  final String content;
  final Chatter sender;
  final Chatter receiver;
  final DateTime createdAt;

  Message({
    required this.content,
    required this.sender,
    required this.receiver,
    required this.createdAt
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'],
      sender: Chatter.fromJson(json['sender']),
      receiver: Chatter.fromJson(json['receiver']),
      createdAt: DateTime.parse(json['createdAt'])
    );
  }
}