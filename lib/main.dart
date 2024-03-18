import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studenthub/pages/favorite_projects_page.dart';
import 'package:studenthub/pages/mock_dashboard_page.dart';
import 'package:studenthub/pages/mock_message_page.dart';
import 'package:studenthub/pages/project_detail_page.dart';
import 'package:studenthub/pages/project_list_page.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.blue,
  ));
  runApp(const StudentHub());
}

class StudentHub extends StatelessWidget {
  const StudentHub({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/list',
      routes: {
        '/list': (context) => ProjectListPage(),
        '/dashboard': (context) => MockDashboardPage(),
        '/message': (context) => MessagePage(),
        '/detail': (context) => ProjectDetailPage(),
      },
    );
  }
}
