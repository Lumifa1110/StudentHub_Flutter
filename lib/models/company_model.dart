class Project {
  final String title;
  final String implementationTime;
  final int qualityStudent;
  final String describe;
  final String createdAt;

  Project(
      {required this.title,
      required this.implementationTime,
      required this.qualityStudent,
      required this.describe,
      required this.createdAt});
}

class ProjectPost {
  late String companyId;
  late int projectScopeFlag;
  late String title;
  late int numberOfStudents;
  late String description;
  late int typeFlag;

  ProjectPost(
    this.companyId,
    this.projectScopeFlag,
    this.title,
    this.numberOfStudents,
    this.description,
    this.typeFlag,
  );

  Map<String, dynamic> toJson() {
    return {
      'companyId': companyId,
      'projectScopeFlag': projectScopeFlag,
      'title': title,
      'numberOfStudents': numberOfStudents,
      'description': description,
      'typeFlag': typeFlag,
    };
  }
}
