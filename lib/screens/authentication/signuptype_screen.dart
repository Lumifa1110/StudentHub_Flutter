import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/radiolisttypes.dart';
import 'package:studenthub/enums/user_role.dart';
import 'package:studenthub/utils/colors.dart';
import 'index.dart';

class SignupTypeScreen extends StatefulWidget {
  const SignupTypeScreen({super.key});

  @override
  State<SignupTypeScreen> createState() => _SignupTypeScreenState();
}

class _SignupTypeScreenState extends State<SignupTypeScreen> {
  UserRole _selectedType = UserRole.student;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const AuthAppBar(
        canBack: false,
        isShowIcon: false,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Text(
            'Join as Company or Student',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
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
              border: Border.all(color: lightestgrayColor, width: 1.0),
              borderRadius: BorderRadius.circular(9),
              color: Theme.of(context).colorScheme.primary,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(0.8),
                  blurRadius: 5.0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignupInfoScreen(selectedType: _selectedType),
                  ),
                );
              },
              child: const Text(
                'Create account',
                style: TextStyle(
                  fontSize: 22,
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
              Text(
                'Already have an account?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onSurface,
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
                  Navigator.pushReplacementNamed(context, '/signin');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
