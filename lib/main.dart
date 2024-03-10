import 'package:flutter/material.dart';
import  'pages/index.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const StudentProfileInputScreen(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/company':
            return MaterialPageRoute(builder: (context) => const CompanyProfileInputScreen());
          case '/company/profile':
            return MaterialPageRoute(builder: (context) => const CompanyProfileInputScreen());
          case '/company/welcome':
            return MaterialPageRoute(builder: (context) => const CompanyWelcomeScreen());
          case '/company/dashboard':
            return MaterialPageRoute(builder: (context) => const CompanyDashboardScreen());
          case '/student':
            return MaterialPageRoute(builder: (context) => const StudentProfileInputScreen());
          case '/student/profile':
            return MaterialPageRoute(builder: (context) => const StudentProfileInputScreen());
          default:
            return null;
        }
      },
    );
  }
}