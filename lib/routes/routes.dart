import 'package:flutter/material.dart';
import 'package:studenthub/components/radiolisttypes.dart';
import 'package:studenthub/pages/signin_page.dart';
import 'package:studenthub/pages/signupinfo_page.dart';
import 'package:studenthub/pages/signuptype_page.dart';

var customRoutes = <String, WidgetBuilder>{
  '/': (context) => SigninPage(),
  '/signin': (context) => SigninPage(),
  '/signup/step1': (context) => SignupTypePage(),
  '/signup/:type': (context, {arguments}) {
    // Extract the type parameter from the arguments
    final AccountTypes type = AccountTypes.company;
    return SignupInfoPage(selectedType: type);
  },
};
