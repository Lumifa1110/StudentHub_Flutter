import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/textfield_floatinglabel.dart';
import 'package:studenthub/models/user_model.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/services/index.dart';
import 'package:studenthub/theme/theme_controller.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<String> errorMessages = [];

  bool isDark = false;

  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    loadToken();
  }

  Future<void> loadToken() async {
    prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  Future<void> handleSignin() async {
    final prefs = await SharedPreferences.getInstance();
    final User user = User(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );

    final Map<String, dynamic> signInResponse = await AuthService.signIn(
      {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      },
    );

    print(signInResponse);

    if (signInResponse['result'] == null) {
      final errorDetails = signInResponse['errorDetails'];
      setState(() {
        if (errorDetails is List<dynamic>) {
          errorMessages = errorDetails.cast<String>();
        } else if (errorDetails is String) {
          errorMessages = [errorDetails];
        }
      });
    } else {
      // SAVE LOCAL: email + password
      final userJson = user.toJson();
      await prefs.setString('user', jsonEncode(userJson));

      // Retrieve existing signed-in accounts
      final List<String>? signedInAccountsJson = prefs.getStringList('signed_in_accounts');
      List<User> signedInAccounts = [];
      if (signedInAccountsJson != null) {
        signedInAccounts =
            signedInAccountsJson.map((json) => User.fromJson(jsonDecode(json))).toList();
      }
      bool accountExists = signedInAccounts.any((account) => account.email == user.email);
      if (!accountExists) {
        final userJson = user.toJson();
        await prefs.setString('user', jsonEncode(userJson));

        signedInAccounts.add(User(email: user.email, password: user.password));
        await prefs.setStringList('signed_in_accounts',
            signedInAccounts.map((account) => jsonEncode(account.toJson())).toList());
      }

      final token = signInResponse['result']['token'];
      await prefs.setString('token', token);

      // FETCH: user data
      await fetchUserData();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      // API: get user data
      final Map<String, dynamic> response = await AuthService.getUserInfo();
      final userData = response['result'];

      // SAVE LOCAL: user id + fullname + roles
      await prefs.setInt('userid', userData['id']);
      await prefs.setString('username', userData['fullname']);
      List<dynamic> roles = userData['roles'];
      List<String> rolesStringList = roles.map((role) => role.toString()).toList();
      await prefs.setStringList('roles', rolesStringList);

      // SAVE LOCAL: user profiles
      await prefs.setString('student_profile', jsonEncode(userData['student']));
      print(jsonEncode(userData['student']));
      await prefs.setString('company_profile', jsonEncode(userData['company']));
      print(jsonEncode(userData['company']));
    } else {
      // Handle case where token is not available
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      resizeToAvoidBottomInset: false,
      appBar: const AuthAppBar(
        canBack: false,
        isShowIcon: false,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () {
                isDark = !isDark;
                Provider.of<ThemeController>(context, listen: false).toggleTheme(isDark);
              },
              child: const Image(
                height: 120,
                width: 120,
                image: AssetImage('assets/images/smileyface.png'),
              ),
            ),
            Text(
              'Login with StudentHub!',
              style: TextStyle(
                fontSize: 33,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // TextField for Username or email
            TextFieldFloatingLabel(label: 'Email', controller: emailController),
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
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Text(
                        error,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
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

            // TextField for Password
            TextFieldFloatingLabel(
              label: 'Password',
              controller: passwordController,
              isPassword: true,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (errorMessages.any((error) => error.toLowerCase().contains('password')))
                  ...errorMessages
                      .where((error) => error.toLowerCase().contains('password'))
                      .map((error) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Text(
                        error,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
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

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (errorMessages.any((error) =>
                    error.toLowerCase().contains('user') || error.toLowerCase().contains('inbox')))
                  ...errorMessages
                      .where((error) =>
                          error.toLowerCase().contains('user') ||
                          error.toLowerCase().contains('inbox'))
                      .map((error) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Text(
                        error,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
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
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 1),
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
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/forgotpassword');
                    },
                    child: const Text(
                      'Forgot Password',
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
                  ),
                ],
              ),
            ),
            // Register
            const Spacer(),
            Text(
              '___Don\'t have a StudentHub account ?___',
              style: TextStyle(
                fontSize: AppFonts.h2FontSize,
                color: Theme.of(context).colorScheme.onSurface,
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
