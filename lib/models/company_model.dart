class Project {
  final int? projectId;
  final String createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? companyId;
  final int? projectScopeFlag;
  final String title;
  final String? description;
  final int? numberOfStudents;
  final int? typeFlag;
  final int? countProposals;
  final bool? isFavorite;

  Project(
      {required this.projectId,
      required this.createdAt,
      required this.updatedAt,
      required this.deletedAt,
      required this.companyId,
      required this.projectScopeFlag,
      required this.title,
      required this.description,
      required this.numberOfStudents,
      required this.typeFlag,
      required this.countProposals,
      required this.isFavorite});
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['projectId'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      companyId: json['companyId'],
      projectScopeFlag: json['projectScopeFlag'],
      title: json['title'],
      description: json['description'],
      numberOfStudents: json['numberOfStudents'],
      typeFlag: json['typeFlag'],
      countProposals: json['countProposals'],
      isFavorite: json['isFavorite'],
    );
  }
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
