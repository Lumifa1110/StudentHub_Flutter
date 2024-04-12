class Language {
  final int id;
  final String languageName;
  final String level;

  const Language({
    required this.id,
    required this.languageName,
    required this.level
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'languageName': languageName,
      'level': level
    };
  }
}
