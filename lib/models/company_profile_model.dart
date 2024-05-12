class CompanyProfile {
  final String title;
  final int size;
  final String website;
  final String description;

  const CompanyProfile({
    required this.title,
    required this.size,
    required this.website,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'companyName': title,
      'size': size,
      'website': website,
      'description': description,
    };
  }
}
