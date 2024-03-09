import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studenthub/pages/signin_page.dart';
import 'package:studenthub/pages/signuptype_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.blue,
  ));
  runApp(const StudentHub());
}

class StudentHub extends StatelessWidget {
  const StudentHub({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SigninPage(),
    );
  }
}
