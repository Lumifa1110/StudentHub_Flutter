import 'package:flutter/material.dart';
import 'package:studenthub/components/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState() => _CompanyDashboardScreenState();
}

class _CompanyDashboardScreenState extends State<CompanyDashboardScreen> {
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
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column (
            children: [
              // J
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Your jobs:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal
                    ),
                  ),
                  ButtonSimple(
                    label: 'Post a job', 
                    onPressed: () => {
                      Navigator.pushNamed(context, 'company/dashboard')
                    }
                  )
                ]
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 40, bottom: 20),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      child: const Text(
                        'Welcome, Company!\nYou have no jobs posted.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal
                        ),
                      )
                    ),
                  ),
                ]
              ),
            ],
          )
        )
      )
    );
  }
}