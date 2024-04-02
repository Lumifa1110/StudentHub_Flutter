import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/textfield_floatinglabel.dart';
import 'package:studenthub/enums/user_role.dart';
import 'package:studenthub/utils/colors.dart';

class SignupInfoPage extends StatefulWidget {
  final UserRole selectedType;

  const SignupInfoPage({
    super.key,
    required this.selectedType,
  });

  @override
  State<SignupInfoPage> createState() => _SignupInfoPageState();
}

class _SignupInfoPageState extends State<SignupInfoPage> {
  bool? _isAgree = false;
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: const AuthAppBar(
        canBack: false,
      ),
      body: Center(
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
            const SizedBox(
              height: 20,
            ),
            TextFieldFloatingLabel(
                label: 'Work email address', controller: _emailController),
            const SizedBox(
              height: 20,
            ),
            TextFieldFloatingLabel(
              label: 'Password',
              controller: _passwordController,
              isPassword: true,
            ),
            const SizedBox(
              height: 10,
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
                onPressed: () {},
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
                              Shadow(color: Colors.blue, offset: Offset(0, -3))
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
                              Shadow(color: Colors.blue, offset: Offset(0, -3))
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
    );
  }
}
