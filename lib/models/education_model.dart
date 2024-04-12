class Education {
  final int id;
  final String educationName;
  final int startYear;
  final int? endYear;

  const Education({
    required this.id,
    required this.educationName,
    required this.startYear,
    this.endYear
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'educationName': educationName,
      'startYear': startYear,
      'endYear': endYear
    };
  }
}
