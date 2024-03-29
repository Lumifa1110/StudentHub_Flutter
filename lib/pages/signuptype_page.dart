import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/radiolisttypes.dart';
import 'package:studenthub/enums/user_role.dart';
import 'package:studenthub/pages/signin_page.dart';
import 'package:studenthub/pages/signupinfo_page.dart';
import 'package:studenthub/utils/colors.dart';

class SignupTypePage extends StatefulWidget {
  const SignupTypePage({super.key});

  @override
  State<SignupTypePage> createState() => _SignupTypePageState();
}

class _SignupTypePageState extends State<SignupTypePage> {
  UserRole _selectedType = UserRole.student;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(
        canBack: false,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          const Text(
            'Join as Company or Student',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: blackTextColor,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          RadioListTypes(
            selectedType: _selectedType,
            onTypeSelected: (type) {
              setState(() {
                _selectedType = type;
              });
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(0),
            decoration: BoxDecoration(
              border: Border.all(color: blackTextColor, width: 2.0),
              color: mainColor,
              boxShadow: const [
                BoxShadow(
                  color: blackTextColor,
                  offset: Offset(0, 0),
                  blurRadius: 1.0,
                  spreadRadius: 1.0,
                ),
              ],
            ),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SignupInfoPage(selectedType: _selectedType),
                  ),
                );
              },
              child: const Text(
                'Create account',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Already have an account?',
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
                  'Log in',
                  style: TextStyle(
                    shadows: [Shadow(color: mainColor, offset: Offset(0, -3))],
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.transparent,
                    decoration: TextDecoration.underline,
                    decorationColor: mainColor,
                    decorationThickness: 2,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SigninPage()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
