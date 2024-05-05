import 'package:studenthub/models/company_model.dart';
import 'package:studenthub/models/index.dart';

class Message {
  final String content;
  final Chatter sender;
  final Chatter receiver;
  final DateTime createdAt;
  final Project? project;
  final Interview? interview;

  Message({
    required this.content,
    required this.sender,
    required this.receiver,
    required this.createdAt,
    this.project,
    this.interview
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'],
      sender: Chatter.fromJson(json['sender']),
      receiver: Chatter.fromJson(json['receiver']),
      createdAt: DateTime.parse(json['createdAt']),
      project: json['project'] != null ? Project.fromJson(json['project']) : null,
      interview: json['interview'] != null ? Interview.fromJson(json['interview']) : null
    );
  }
}