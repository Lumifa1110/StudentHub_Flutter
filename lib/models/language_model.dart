class Language {
  final int id;
  final String languageName;
  final String level;
  final DateTime? updatedAt;
  final DateTime? deletedAt;

  Language({
    required this.id,
    required this.languageName,
    required this.level,
    this.updatedAt,
    this.deletedAt,
  });

  factory Language.fromJson(Map<String, dynamic> json) {
    return Language(
      id: json['id'],
      languageName: json['languageName'],
      level: json['level'],
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null
    );
  }
}