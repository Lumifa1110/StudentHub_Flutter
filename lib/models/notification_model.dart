import 'package:flutter/foundation.dart';
import 'package:studenthub/enums/index.dart';
import 'package:studenthub/models/company_model.dart';
import 'package:studenthub/models/index.dart';

class NotificationModel {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final int senderId;
  final int receiverId;
  final int? messageId;
  final String title;
  final NotifyFlag notifyFlag;
  final TypeNotifyFlag typeNotifyFlag;
  final int? proposalId;
  final String content;
  final Message? message;
  final Chatter? sender;
  final Chatter? receiver;
  final Interview? interview;
  final MeetingRoom? meetingRoom;
  final Proposal? proposal;


  NotificationModel({
    required this.id,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    required this.senderId,
    required this.receiverId,
    this.messageId,
    required this.title,
    required this.notifyFlag,
    required this.typeNotifyFlag,
    this.proposalId,
    required this.content,
    this.message,
    this.sender,
    this.receiver,
    this.interview,
    this.meetingRoom,
    this.proposal,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updated'] != null ? DateTime.parse(json['updatedAt']) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      messageId: json['messageId'],
      title: json['title'],
      notifyFlag: mapNotifyFlag(json['notifyFlag']),
      typeNotifyFlag: mapTypeNotifyFlag(json['typeNotifyFlag']),
      proposalId: json['proposalId'],
      content: json['content'],
      message: json['message'] != null ? Message.fromJson(json['message']) : null,
      sender: json['sender'] != null ? Chatter.fromJson(json['sender']) : null,
      receiver: json['receiver'] != null ? Chatter.fromJson(json['receiver']) : null,
      interview: json['interview'] != null ? Interview.fromJson(json['interview']) : null,
      meetingRoom: json['meetingRoom'] != null ? MeetingRoom.fromJson(json['meetingRoom']) : null,
      proposal: json['proposal'] != null ? Proposal.fromJson(json['proposal']) : null
    );
  }

  static NotifyFlag mapNotifyFlag(String? notifyFlagString) {
    switch (notifyFlagString) {
      case '0':
        return NotifyFlag.unread;
      case '1':
        return NotifyFlag.read;
      default:
        throw ArgumentError('Invalid notifyFlagString: $notifyFlagString');
    }
  }

  static TypeNotifyFlag mapTypeNotifyFlag(String? typeNotifyFlagString) {
    switch (typeNotifyFlagString) {
      case '0':
        return TypeNotifyFlag.offer;
      case '1':
        return TypeNotifyFlag.interview;
      case '2':
        return TypeNotifyFlag.submitted;
      case '3':
        return TypeNotifyFlag.chat;
      case '4':
        return TypeNotifyFlag.hired;


      default:
        throw ArgumentError('Invalid notifyFlagString: $typeNotifyFlagString');
    }
  }
}


class Proposal{
  final int ?statusFlag;

  Proposal({this.statusFlag});

  factory Proposal.fromJson(Map<String, dynamic> json) {
    return Proposal(
      statusFlag: json['statusFlag']
    );
  }

}
