import 'package:studenthub/models/index.dart';

class Interview {
  final int? id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final bool? disableFlag;
  final int meetingRoomId;
  final MeetingRoom? meetingRoom;

  Interview({
    this.id,
    this.createdAt,
    this.updatedAt,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.disableFlag,
    required this.meetingRoomId,
    this.meetingRoom
  });

  factory Interview.fromJson(Map<String, dynamic> json) {
    return Interview(
      id: json['id'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      title: json['title'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      disableFlag: json['disableFlag'] != null,
      meetingRoomId:  json['meetingRoomId'],
      meetingRoom: json['meetingRoom'] != null ? MeetingRoom.fromJson(json['meetingRoom']) : null
    );
  }
}