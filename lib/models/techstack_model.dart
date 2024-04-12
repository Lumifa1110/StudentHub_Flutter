class TechStack {
  final int id;
  final String name;

  const TechStack({
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