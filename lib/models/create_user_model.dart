class CreateUser {
  final String email;
  final String password;
  final String fullname;
  final int role;

  const CreateUser({
    required this.email,
    required this.password,
    required this.fullname,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'fullname': fullname,
      'role': role,
    };
  }
}
