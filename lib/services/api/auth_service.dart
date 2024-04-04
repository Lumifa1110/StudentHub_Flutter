import 'package:studenthub/models/user_model.dart';

class AuthServices {
  Future<void> signin() async {
    final User user = User(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    // print(user.toJson());
    try {
      final response = await http.post(
        Uri.parse('http://34.16.137.128/api/auth/sign-in'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()),
      );
      print('Res: ${response.body}');

      if (response.statusCode == 201) {
        // Lưu token vào SharedPreferences
        final token = jsonDecode(response.body)['result']['token'];
        fetchUserData();
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setInt('currole', widget.role.index);
      } else {
        print('Error: ${response.statusCode}');
        final errorBody = jsonDecode(response.body);
        final errorDetails = errorBody['errorDetails'];
        if (errorDetails is List<dynamic>) {
          setState(() {
            errorMessages.clear();
            errorMessages.addAll(errorDetails.cast<String>());
          });
        } else if (errorDetails is String) {
          setState(() {
            errorMessages.clear();
            errorMessages.add(errorDetails);
          });
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
