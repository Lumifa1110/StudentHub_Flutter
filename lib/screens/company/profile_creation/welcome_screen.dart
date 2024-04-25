import 'package:flutter/material.dart';
import 'package:studenthub/components/button_simple.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/screens/index.dart';

class CompanyWelcomeScreen extends StatelessWidget {
  const CompanyWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Student Hub',
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            FaIcon(
              FontAwesomeIcons.solidUser,
              color: Color(0xffffffff),
              size: 24
            )
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column (
            children: [
              // TEXT: Welcome
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 40, bottom: 20),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.topCenter,
                      child: const Text('Welcome to Student Hub, Company!\nLet\'s start with your first project post!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal
                        ),
                      )
                    ),
                  ),
                ]
              ),
              ButtonSimple(
                label: 'Get started!', 
                onPressed: () => {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MainScreen()))
                }
              )
            ]
          )
        )
      )
    );
  }
}