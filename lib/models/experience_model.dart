import 'package:studenthub/models/index.dart';

class Experience {
  final int id;
  final String title;
  final String startMonth;
  final String endMonth;
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
      'skillets': skillsets.map((skillset) => skillset.id.toString()).toList()
    };
  }
}
