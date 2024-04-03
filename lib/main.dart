import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studenthub/enums/user_role.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/theme/theme.dart';
import 'package:studenthub/theme/theme_controller.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.blue,
  ));
  runApp(const StudentHub());
}

ThemeController _themeController = ThemeController();

class StudentHub extends StatefulWidget {
  const StudentHub({super.key});

  @override
  State<StudentHub> createState() => _StudentHubState();
}

class _StudentHubState extends State<StudentHub> {
  @override
  void dispose() {
    _themeController.removeListener(themeListener);
    super.dispose();
  }

  @override
  void initState() {
    _themeController.addListener(themeListener);
    super.initState();
  }

  themeListener() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      theme: lightTheme,
      darkTheme: darkTheme,
      // themeMode: _themeController.themeMode,
      home: const SwitchScreen(),
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/company':
            return MaterialPageRoute(
                builder: (context) => const CompanyProfileInputScreen());
          case '/company/profile':
            return MaterialPageRoute(
                builder: (context) => const CompanyProfileInputScreen());
          case '/company/welcome':
            return MaterialPageRoute(
                builder: (context) => const CompanyWelcomeScreen());
          case '/company/dashboard':
            return MaterialPageRoute(
                builder: (context) => const CompanyDashboardScreen());
          case '/student':
            return MaterialPageRoute(
                builder: (context) => const StudentProfileInputScreen1());
          case '/student/profileinput1':
            return MaterialPageRoute(
                builder: (context) => const StudentProfileInputScreen1());
          case '/chatter':
            return MaterialPageRoute(
                builder: (context) => const MessageListScreen());
          // case '/signin':
          //   return MaterialPageRoute(builder: (context) => const SigninPage());
          case '/signup':
            return MaterialPageRoute(
                builder: (context) => const SignupTypeScreen());
          case '/signup/company':
            return MaterialPageRoute(
              builder: (context) =>
                  const SignupInfoScreen(selectedType: UserRole.company),
            );
          case '/signup/student':
            return MaterialPageRoute(
              builder: (context) =>
                  const SignupInfoScreen(selectedType: UserRole.student),
            );
          case '/list':
            return MaterialPageRoute(
                builder: (context) => const ProjectListScreen());
          default:
            return null;
        }
      },
    );
  }
}
