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
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String uriBase = 'http://34.16.137.128';

  List<String> errorMessages = [];

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
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> handleSignin() async {
    final prefs = await SharedPreferences.getInstance();
    final User user = User(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );
    final userJson = user.toJson();
    await prefs.setString('user', jsonEncode(userJson));
    // print(user.toJson());

    try {
      final response = await http.post(
        Uri.parse('$uriBase/api/auth/sign-in'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()),
      );
      print('Res: ${response.body}');
      print(response.statusCode);

      if (response.statusCode == 201) {
        final result = jsonDecode(response.body)["result"];
        final token = result['token'];
        print('Token: $token');
        await prefs.setString('token', token);
        await fetchUserData();
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        print('Error this: ${response.statusCode}');
        final errorDetails = jsonDecode(response.body)['errorDetails'];
        setState(() {
          if (errorDetails is List<dynamic>) {
            errorMessages = errorDetails.cast<String>();
          } else if (errorDetails is String) {
            errorMessages = [errorDetails];
          }
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.get(
          Uri.parse('$uriBase/api/auth/me'),
          headers: {'Authorization': 'Bearer $token'},
        );
        print('Fetch User Data: ${response.body}');
        if (response.statusCode == 200) {
          final userData = jsonDecode(response.body)['result'];
          print('User Data:  $userData');

          // Save user id
          await prefs.setInt('userid', userData['id']);
          print('User ID: ${userData['id']}');

          // Save user full name
          await prefs.setString('username', userData['fullname']);
          print('User FullName: ${userData['fullname']}');

          // Save roles
          List<dynamic> roles = userData['roles'];
          List<String> rolesStringList =
              roles.map((role) => role.toString()).toList();
          await prefs.setStringList('roles', rolesStringList);
          print('User assigned roles: ${userData['roles']}');

          // Save student profile
          await prefs.setString(
              'studentprofile', jsonEncode(userData['student']));
          print('User role Student: ${jsonEncode(userData['student'])}');

          // Save company profile
          await prefs.setString(
              'companyprofile', jsonEncode(userData['company']));
          print('User role Company: ${jsonEncode(userData['company'])}');
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
            const SizedBox(
              height: 20,
            ),
            // TextField for Username or email
            TextFieldFloatingLabel(
                label: 'Email', controller: _emailController),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (errorMessages.any((error) =>
                    error.toLowerCase().contains('email') &&
                    !error.toLowerCase().contains('inbox')))
                  ...errorMessages
                      .where((error) =>
                          error.toLowerCase().contains('email') &&
                          !error.toLowerCase().contains('inbox'))
                      .map((error) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Text(
                        error,
                        style: const TextStyle(
                          color: errorColor,
                          fontSize: AppFonts.h3FontSize,
                        ),
                      ),
                    );
                  }).toList()
                else
                  const SizedBox(
                    height: 20,
                  ),
              ],
            ),

            // TextField for Password
            TextFieldFloatingLabel(
              label: 'Password',
              controller: _passwordController,
              isPassword: true,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (errorMessages
                    .any((error) => error.toLowerCase().contains('password')))
                  ...errorMessages
                      .where(
                          (error) => error.toLowerCase().contains('password'))
                      .map((error) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Text(
                        error,
                        style: const TextStyle(
                          color: errorColor,
                          fontSize: AppFonts.h3FontSize,
                        ),
                      ),
                    );
                  }).toList()
                else
                  const SizedBox(
                    height: 20,
                  ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (errorMessages.any((error) =>
                    error.toLowerCase().contains('user') ||
                    error.toLowerCase().contains('inbox')))
                  ...errorMessages
                      .where((error) =>
                          error.toLowerCase().contains('user') ||
                          error.toLowerCase().contains('inbox'))
                      .map((error) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Text(
                        error,
                        style: const TextStyle(
                          color: errorColor,
                          fontSize: AppFonts.h3FontSize,
                        ),
                      ),
                    );
                  }).toList()
                else
                  const SizedBox(
                    height: 0,
                  ),
              ],
            ),
            // Hiển thị thông báo lỗi
            // if (errorMessages.isNotEmpty)
            //   Column(
            //     crossAxisAlignment: CrossAxisAlignment.stretch,
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: errorMessages.map((error) {
            //       return Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 20),
            //         child: Text(
            //           error,
            //           style: const TextStyle(
            //               color: errorColor, fontSize: AppFonts.h3FontSize),
            //         ),
            //       );
            //     }).toList(),
            //   ),

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
                  Navigator.pushNamed(context, '/signup');
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
