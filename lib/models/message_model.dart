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
      sender: json['sender'].map((json) => Chatter.fromJson(json)),
      receiver: json['receiver'].map((json) => Chatter.fromJson(json)),
      createdAt: DateTime.parse(json['createdAt'])
    );
  }
}