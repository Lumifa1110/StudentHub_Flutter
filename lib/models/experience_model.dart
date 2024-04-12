import 'package:studenthub/models/index.dart';

class Experience {
  final int id;
  final String title;
  final DateTime startMonth;
  final DateTime endMonth;
  final String description;
  final List<SkillSet> skillsets;

  const Experience({
    required this.id,
    required this.title,
    required this.startMonth,
    required this.endMonth,
    required this.description,
    required this.skillsets
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'startMonth': startMonth,
      'endMonth': endMonth,
      'description': description,
      'skillsets': skillsets
    };
  }
}
