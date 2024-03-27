import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studenthub/components/radiolisttypes.dart';
// import 'package:studenthub/data/test/data_project.dart';
import 'package:studenthub/pages/chat_flow/chat_screen.dart';
// import 'package:studenthub/pages/company_review_proposal/project_proposal_list.dart';
import 'package:studenthub/pages/home_page.dart';
import 'package:studenthub/pages/signin_page.dart';
import 'package:studenthub/pages/signupinfo_page.dart';
import 'package:studenthub/pages/signuptype_page.dart';
import 'pages/index.dart';

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
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
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
            return MaterialPageRoute(builder: (context) => const ChatScreen());
          case '/signin':
            return MaterialPageRoute(builder: (context) => const SigninPage());
          case '/signup/step1':
            return MaterialPageRoute(
                builder: (context) => const SignupTypePage());
          case '/signup/step2':
            MaterialPageRoute(builder: (context, {arguments}) {
              // Extract the type parameter from the arguments
              final AccountTypes type = AccountTypes.company;
              return SignupInfoPage(selectedType: type);
            });
          default:
            return null;
        }
      },
    );
  }
}
