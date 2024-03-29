import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/textfield_floatinglabel.dart';
import 'package:studenthub/pages/signuptype_page.dart';
import 'package:studenthub/utils/colors.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  // bool _isObscure = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
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
            TextFieldFloatingLabel(
                label: 'Username or Email', controller: _usernameController),

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
                    MaterialPageRoute(
                        builder: (context) => const SignupTypePage()),
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
