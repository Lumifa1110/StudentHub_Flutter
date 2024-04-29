class Chatter {
  final int id;
  final String fullname;

  Chatter({
    required this.id,
    required this.fullname
  });

  factory Chatter.fromJson(Map<String, dynamic> json) {
    return Chatter(
      id: json['id'],
      fullname: json['fullname']
    );
  }
}