class Education {
  final int id;
  final String schoolName;
  final DateTime startYear;
  final DateTime? endYear;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Education({
    required this.id,
    required this.schoolName,
    required this.startYear,
    this.endYear,
    this.updatedAt,
    this.deletedAt,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    print(json['id'].runtimeType);
    return Education(
        id: json['id'],
        schoolName: json['schoolName'],
        startYear: DateTime(json['startYear'], 1, 1),
        endYear: json['endYear'] != null ? DateTime(json['endYear'], 1, 1) : null,
        updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
        deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null);
  }
}
