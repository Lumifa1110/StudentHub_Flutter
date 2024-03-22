import 'package:flutter/material.dart';
import 'pages/project_post_step1_page.dart';
import 'pages/project_post_step2_page.dart';
import 'pages/project_post_step3_page.dart';
import 'pages/project_post_step4_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/DashboardList/Dashboard_ViewProjectList.dart';


void main() {
  runApp( MyApp());
}
class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Dashboard_ViewListProject_page(),
      ),
    ) ;
  }
}