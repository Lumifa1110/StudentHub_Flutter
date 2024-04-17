import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/textfield_floatinglabel.dart';
import 'package:studenthub/enums/user_role.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/services/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

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
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool? _isAgree = false;
  List<String> errorMessages = [];

  Future<void> handleSignup() async {
    if (!_isAgree!) {
      setState(() {
        errorMessages.clear();
        errorMessages.add("Please agree to the terms and conditions.");
      });
      return; // Stop further execution
    }

    // API: sign-up
    await AuthService.signUp({
      "email": emailController.text.trim(),
      "password": passwordController.text.trim(),
      "fullname": fullnameController.text.trim(),
      "role": widget.selectedType.index
    });

    // NAVIGATE TO: sign-in screen
    if (mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentProfileInputScreen1()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: const AuthAppBar(
        canBack: true,
        isShowIcon: false,
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
                  label: 'Fullname', controller: fullnameController),
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
                    })
                  else
                    const SizedBox(
                      height: 20,
                    ),
                ],
              ),
              TextFieldFloatingLabel(
                  label: 'Work email address', controller: emailController),
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
                    })
                  else
                    const SizedBox(
                      height: 20,
                    ),
                ],
              ),
              TextFieldFloatingLabel(
                label: 'Password',
                controller: passwordController,
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
                    })
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
