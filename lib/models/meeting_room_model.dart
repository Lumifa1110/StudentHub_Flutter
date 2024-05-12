class MeetingRoom {
  final int id;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String meetingRoomCode;
  final String meetingRoomId;
  final DateTime expiredAt;

  MeetingRoom({
    required this.id,
    this.createdAt,
    this.updatedAt,
    required this.meetingRoomCode,
    required this.meetingRoomId,
    required this.expiredAt
  });

  factory MeetingRoom.fromJson(Map<String, dynamic> json) {
    return MeetingRoom(
      id: json['id'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      meetingRoomCode: json['meeting_room_code'],
      meetingRoomId:  json['meeting_room_id'],
      expiredAt: DateTime.parse(json['expired_at'])
    );
  }
}