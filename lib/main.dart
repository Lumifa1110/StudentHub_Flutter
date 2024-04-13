import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studenthub/enums/user_role.dart';
import 'package:studenthub/screens/authentication/changepassword_screen.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/theme/theme.dart';
import 'package:studenthub/theme/theme_controller.dart';
import 'package:studenthub/utils/colors.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: AppColor.primary,
      systemNavigationBarColor: AppColor.primary));
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
      initialRoute: '/signin',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(builder: (context) => const HomeScreen());
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
                builder: (context) => CompanyDashboardScreen());
          case '/student':
            return MaterialPageRoute(
                builder: (context) => const StudentProfileInputScreen1());
          case '/student/profileinput1':
            return MaterialPageRoute(
                builder: (context) => const StudentProfileInputScreen1());
          case '/student/dashboard':
            return MaterialPageRoute(
                builder: (context) => const StudentDashboardScreen());
          case '/chatter':
            return MaterialPageRoute(
                builder: (context) => const MessageListScreen());
          case '/signin':
            return MaterialPageRoute(
                builder: (context) => const SigninScreen());
          case '/user/changepassword':
            return MaterialPageRoute(
                builder: (context) => const ChangePasswordScreen());
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
          case '/profile':
            return MaterialPageRoute(
              builder: (context) => const SwitchScreen(),
            );
          case '/list':
            return MaterialPageRoute(
                builder: (context) => const ProjectListScreen());
          case '/company/project/step1':
            return MaterialPageRoute(
                builder: (context) => ProjectPostStep1Page());
          default:
            return null;
        }
      },
    );
  }
}
