class Project {
  final int projectId;
  final String createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? companyId;
  final String? companyName;
  final int? projectScopeFlag;
  final String title;
  final String? description;
  final int? numberOfStudents;
  final int? typeFlag;
  final int? countProposals;
  final bool? isFavorite;

  Project({
    required this.projectId,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.companyId,
    required this.companyName,
    required this.projectScopeFlag,
    required this.title,
    required this.description,
    required this.numberOfStudents,
    required this.typeFlag,
    required this.countProposals,
    required this.isFavorite,
  });
  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      projectId: json['projectId'] ?? json['id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      deletedAt: json['deletedAt'],
      companyId: json['companyId'],
      companyName: json['companyName'],
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

class TechStack {
  final int? id;
  final String? name;

  TechStack({required this.id, required this.name});
}

class Student {
  final int id;
  final String fullname;
  final TechStack techStack;

  Student({required this.id, required this.fullname, required this.techStack});
}

class ItemsProposal {
  final int id;
  final String coverLetter;
  final int statusFlag;
  final int disableFlag;
  final Student student;

  ItemsProposal(
      {required this.id,
      required this.coverLetter,
      required this.statusFlag,
      required this.disableFlag,
      required this.student});
}

class Proposal {
  final int total;
  final List<ItemsProposal> items;

  Proposal({required this.total, required this.items});
}
