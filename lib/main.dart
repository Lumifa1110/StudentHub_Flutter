import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studenthub/data/test/data_project.dart';
import 'package:studenthub/pages/company_review_proposal/project_proposal_list.dart';
import  'pages/index.dart';

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
      home: ProjectProposalListScreen(project: dataProject[0]),
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
            return MaterialPageRoute(builder: (context) => const StudentProfileInputScreen1());
          case '/student/profileinput1':
            return MaterialPageRoute(builder: (context) => const StudentProfileInputScreen1());
          default:
            return null;
        }
      },
    );
  }
}

