class SkillSet {
  final int id;
  final String name;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  SkillSet({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory SkillSet.fromJson(Map<String, dynamic> json) {
    return SkillSet(
      id: json['id'],
      name: json['name'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    );
  }
}