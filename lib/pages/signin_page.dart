import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/pages/signuptype_page.dart';
import 'package:studenthub/utils/colors.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const AuthAppBar(
        canBack: false,
      ),
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
                    labelText: 'Username or Email',
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
            // TextField for Password
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
              height: 20,
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
                onPressed: () {},
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
                    MaterialPageRoute(builder: (context) => SignupTypePage()),
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
