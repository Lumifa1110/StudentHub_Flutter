import 'package:flutter/material.dart';
import 'package:studenthub/pages/all_project_page.dart';
import 'pages/submit_proposal_page.dart';
import 'pages/all_project_page.dart';


void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return SafeArea(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AllProject(),
        )
    );
  }
}