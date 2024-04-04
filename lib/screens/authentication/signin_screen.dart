import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/textfield_floatinglabel.dart';
import 'package:studenthub/enums/user_role.dart';
import 'package:studenthub/models/user_model.dart';
import 'package:studenthub/screens/authentication/signuptype_screen.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class SigninScreen extends StatefulWidget {
  final UserRole role;

  const SigninScreen({super.key, required this.role});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  List<String> errorMessages = [];
  // bool _isObscure = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    if (token != null) {
      Navigator.pushReplacementNamed(context, '/profile');
    }
  }

  Future<void> handleSignin() async {
    final prefs = await SharedPreferences.getInstance();
    final User user = User(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    final userJson = jsonEncode(user.toJson());
    await prefs.setString('user', userJson);
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

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final current_role = prefs.getInt('currole');

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('http://34.16.137.128/api/auth/me'),
          headers: {'Authorization': 'Bearer $token'},
        );
        print(response.body);
        if (response.statusCode == 200) {
          print('success');
          Navigator.pushReplacementNamed(context, '/profile');
        } else {
          // Handle error
        }
      } catch (e) {
        // Handle network errors
      }
    } else {
      // Handle case where token is not available
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: false,
      appBar: const AuthAppBar(canBack: false),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Image(
              height: 120,
              width: 120,
              image: AssetImage('assets/images/smileyface.png'),
            ),
            const Text(
              'Login with StudentHub!',
              style: TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.bold,
                color: darkblueColor,
              ),
            ),
            // Text(
            //   'as ${widget.role == UserRole.company ? 'Company' : 'Student'}',
            //   style: const TextStyle(
            //     fontSize: 33,
            //     fontWeight: FontWeight.bold,
            //     color: darkblueColor,
            //   ),
            // ),
            const SizedBox(
              height: 20,
            ),
            // TextField for Username or email
            TextFieldFloatingLabel(
                label: 'Email', controller: _emailController),

            const SizedBox(
              height: 20,
            ),
            // TextField for Password
            TextFieldFloatingLabel(
              label: 'Password',
              controller: _passwordController,
              isPassword: true,
            ),
            const SizedBox(
              height: 10,
            ),

            // Hiển thị thông báo lỗi
            if (errorMessages.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: errorMessages.map((error) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      error,
                      style: const TextStyle(
                          color: errorColor, fontSize: AppFonts.h3FontSize),
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 1),
              decoration: BoxDecoration(
                border: Border.all(color: blackTextColor, width: 2.0),
                color: lightgrayColor,
                boxShadow: const [
                  BoxShadow(
                    color: blackTextColor,
                    offset: Offset(3, 3), // Bottom shadow
                  ),
                ],
              ),
              child: TextButton(
                onPressed: handleSignin,
                child: const Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 24,
                    color: whiteTextColor,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            // Register
            const Spacer(),
            const Text(
              '___Don\'t have a StudentHub account ?___',
              style: TextStyle(
                fontSize: 18,
                color: darkgrayColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              padding: const EdgeInsets.symmetric(vertical: 1),
              decoration: BoxDecoration(
                border: Border.all(color: blackTextColor, width: 2.0),
                color: lightgrayColor,
                boxShadow: const [
                  BoxShadow(
                    color: blackTextColor,
                    offset: Offset(2, 2), // Bottom shadow
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignupTypeScreen()),
                  );
                },
                child: const Text(
                  'Sign up',
                  style: TextStyle(
                    fontSize: 24,
                    color: whiteTextColor,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
