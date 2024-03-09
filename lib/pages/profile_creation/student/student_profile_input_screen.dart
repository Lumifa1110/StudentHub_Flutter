import 'package:flutter/material.dart';
import 'package:studenthub/components/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class StudentProfileInputScreen extends StatefulWidget {
  const StudentProfileInputScreen({super.key});

  @override
  State<StudentProfileInputScreen> createState() => _StudentProfileInputScreenState();
}

class _StudentProfileInputScreenState extends State<StudentProfileInputScreen> {
  // TextField controller
  final techStackController = TextEditingController();
  final skillSetController = TextEditingController();

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
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.topCenter,
                      child: const Text('Welcome to Student Hub!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ),
                  ),
                ]
              ),
              // TEXT: Guidance
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.topCenter,
                      child: const Text(
                        'Tell us about yourself and you will be your way connect with real-world projects',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal
                        ),
                      )
                    ),
                  ),
                ]
              ),
              const SizedBox(
                height: 20,
              ),
              // TextFields
              TextFieldWithLabel(label: 'Techstack', controller: techStackController, lineCount: 1),
              TextFieldWithLabel(label: 'Skillsets', controller: skillSetController, lineCount: 1),
              // Continue button
              
              Container(
                alignment: Alignment.bottomRight,
                margin: const EdgeInsets.only(top: 20),
                child: ButtonSimple(
                  label: 'Next', 
                  onPressed: () => {
                    Navigator.pushNamed(context, '/company/welcome')
                  }
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}