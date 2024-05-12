import 'package:studenthub/models/company_model.dart';
import 'package:studenthub/models/index.dart';

class Message {
  final String content;
  final int? senderId;
  final int? receiverId;
  final Chatter? sender;
  final Chatter? receiver;
  final DateTime createdAt;
  final int? projectId;
  final Project? project;
  final Interview? interview;

  Message({
    required this.content,
    this.projectId,
    this.senderId,
    this.receiverId,
    this.sender,
    this.receiver,
    required this.createdAt,
    this.project,
    this.interview
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      content: json['content'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      sender: json['sender'] != null ? Chatter.fromJson(json['sender']) : null,
      receiver: json['receiver'] != null ? Chatter.fromJson(json['receiver']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      project: json['project'] != null ? Project.fromJson(json['project']) : null,
      interview: json['interview'] != null ? Interview.fromJson(json['interview']) : null,
      projectId: json['projectId'],
    );
  }
}