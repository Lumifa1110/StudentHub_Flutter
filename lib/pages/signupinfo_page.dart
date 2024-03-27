import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/radiolisttypes.dart';
import 'package:studenthub/utils/colors.dart';

class SignupInfoPage extends StatefulWidget {
  final AccountTypes selectedType;

  const SignupInfoPage({
    super.key,
    required this.selectedType,
  });

  @override
  State<SignupInfoPage> createState() => _SignupInfoPageState();
}

class _SignupInfoPageState extends State<SignupInfoPage> {
  bool _isObscure = true;
  bool? _isAgree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(
        canBack: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            widget.selectedType == AccountTypes.company
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF636363).withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const TextField(
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  cursorColor: blackTextColor,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hoverColor: Colors.red,
                    filled: true,
                    fillColor: Color(0xFFDFDFDF),
                    labelText: 'Fullname',
                    labelStyle: TextStyle(
                      color: darkgrayColor,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 6, horizontal: 1),
                    floatingLabelStyle: TextStyle(
                      color: mainColor,
                      fontSize: 18,
                      height: 0.6,
                      fontWeight: FontWeight.bold,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: mainColor,
                        width: 3.0,
                      ),
                    ),
                    focusColor: blackTextColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF636363).withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const TextField(
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  cursorColor: blackTextColor,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hoverColor: Colors.red,
                    filled: true,
                    fillColor: Color(0xFFDFDFDF),
                    labelText: 'Work email address',
                    labelStyle: TextStyle(
                      color: darkgrayColor,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 6, horizontal: 1),
                    floatingLabelStyle: TextStyle(
                      color: mainColor,
                      fontSize: 18,
                      height: 0.6,
                      fontWeight: FontWeight.bold,
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: mainColor,
                        width: 3.0,
                      ),
                    ),
                    focusColor: blackTextColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF636363).withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  cursorColor: blackTextColor,
                  obscureText: _isObscure,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(
                      color: darkgrayColor,
                    ),
                    hintText: '8 or more characters',
                    hintStyle:
                        TextStyle(color: blackTextColor.withOpacity(0.5)),
                    filled: true,
                    fillColor: const Color(0xFFDFDFDF),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 1),
                    floatingLabelStyle: const TextStyle(
                      color: mainColor,
                      fontSize: 18,
                      height: 0.6,
                      fontWeight: FontWeight.bold,
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: mainColor,
                        width: 3.0,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                        color: blackTextColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                  ),
                ),
              ),
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
            widget.selectedType == AccountTypes.company
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
                        onTap: () {},
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
                        onTap: () {},
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
