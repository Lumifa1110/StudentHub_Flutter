class Interview {
  final int? id;
  final String title;
  final DateTime startTime;
  final DateTime endTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool? disableFlag;


  Interview({
    this.id,
    required this.title,
    required this.startTime,
    required this.endTime,
    this.createdAt,
    this.updatedAt,
    this.disableFlag
  });

  factory Interview.fromJson(Map<String, dynamic> json) {
    return Interview(
      id: json['id'],
      title: json['title'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      createdAt: json['createdAt'] ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] ? DateTime.parse(json['updatedAt']) : null,
      disableFlag: json['disableFlag'] ? json['disableFlag'] : false
    );
  }
}