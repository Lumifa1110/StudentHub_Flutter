import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/textfield_floatinglabel.dart';
import 'package:studenthub/enums/user_role.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';
import 'package:studenthub/config/config.dart';

class SignupInfoScreen extends StatefulWidget {
  final UserRole selectedType;

  const SignupInfoScreen({
    super.key,
    required this.selectedType,
  });

  @override
  State<SignupInfoScreen> createState() => _SignupInfoScreenState();
}

class _SignupInfoScreenState extends State<SignupInfoScreen> {
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool? _isAgree = false;
  List<String> errorMessages = [];

  Future<void> handleSignup() async {
    final prefs = await SharedPreferences.getInstance();

    if (!_isAgree!) {
      setState(() {
        errorMessages.clear();
        errorMessages.add("Please agree to the terms and conditions.");
      });
      return; // Stop further execution
    }

    final CreateUser createUser = CreateUser(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      fullname: _fullnameController.text.trim(),
      role: widget.selectedType.index,
    );
    final createUserJson = createUser.toJson();

    try {
      final response = await http.post(
        Uri.parse('${uriBase}/api/auth/sign-up'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(createUserJson),
      );

      print(response.body);
      if (response.statusCode == 201) {
        print('success');
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SigninScreen(role: widget.selectedType),
            ));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: const AuthAppBar(
        canBack: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              widget.selectedType == UserRole.company
                  ? const Text(
                      'Sign up as Company',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: blackTextColor,
                      ),
                    )
                  : const Text(
                      'Sign up as Student',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: blackTextColor,
                      ),
                    ),
              const SizedBox(
                height: 20,
              ),
              TextFieldFloatingLabel(
                  label: 'Fullname', controller: _fullnameController),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (errorMessages
                      .any((error) => error.toLowerCase().contains('fullname')))
                    ...errorMessages
                        .where(
                            (error) => error.toLowerCase().contains('fullname'))
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

              TextFieldFloatingLabel(
                  label: 'Work email address', controller: _emailController),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (errorMessages
                      .any((error) => error.toLowerCase().contains('email')))
                    ...errorMessages
                        .where((error) => error.toLowerCase().contains('email'))
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
                      height: 0,
                    ),
                ],
              ),
              CheckboxListTile(
                title: const Text(
                  'Yes, I understand and agree to StudentHub',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                value: _isAgree,
                onChanged: (value) {
                  setState(() {
                    _isAgree = value;
                  });
                },
                activeColor: mainColor,
                checkColor: whiteTextColor,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              // if (errorMessages.isNotEmpty)
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.stretch,
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: errorMessages.map((error) {
              //     return Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 20),
              //       child: Text(
              //         error,
              //         style: const TextStyle(
              //             color: errorColor, fontSize: AppFonts.h3FontSize),
              //       ),
              //     );
              //   }).toList(),
              // ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: errorMessages
                    .where((error) => error.contains('agree'))
                    .map((error) {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text(
                      error,
                      style: const TextStyle(
                          color: errorColor, fontSize: AppFonts.h3FontSize),
                    ),
                  );
                }).toList(),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  border: Border.all(color: lightgrayColor, width: 2.0),
                  color: mainColor,
                  boxShadow: const [
                    BoxShadow(
                      color: lightgrayColor,
                      offset: Offset(0, 0),
                      blurRadius: 1.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: handleSignup,
                  child: const Text(
                    'Create my account',
                    style: TextStyle(
                      fontSize: 20,
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
              widget.selectedType == UserRole.company
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Looking for a project?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          child: const Text(
                            'Apply as Student',
                            style: TextStyle(
                              shadows: [
                                Shadow(
                                    color: Colors.blue, offset: Offset(0, -3))
                              ],
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.transparent,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                              decorationThickness: 2,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/signup/student');
                          },
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Looking for talents?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          child: const Text(
                            'Apply as Company',
                            style: TextStyle(
                              shadows: [
                                Shadow(
                                    color: Colors.blue, offset: Offset(0, -3))
                              ],
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.transparent,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.blue,
                              decorationThickness: 2,
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/signup/company');
                          },
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
