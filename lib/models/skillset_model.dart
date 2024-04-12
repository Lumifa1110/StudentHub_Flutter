class SkillSet {
  final int id;
  final String name;

  const SkillSet({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
