import 'package:flutter/material.dart';
import 'package:studenthub/components/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/models/index.dart';

import '../student_dashboard.dart';

class StudentProfileInputScreen3 extends StatefulWidget {
  const StudentProfileInputScreen3({
    super.key,
  });

  @override
  State<StudentProfileInputScreen3> createState() =>
      _StudentProfileInputScreen3State();
}

class _StudentProfileInputScreen3State
    extends State<StudentProfileInputScreen3> {
  final List<SkillSet> skillsets1 = [
    SkillSet(id: 0, name: 'C'),
    SkillSet(id: 1, name: 'C++'),
    SkillSet(id: 2, name: 'C#'),
    SkillSet(id: 3, name: 'Python'),
    SkillSet(id: 4, name: 'Java'),
    SkillSet(id: 5, name: 'JavaScript'),
    SkillSet(id: 6, name: 'Kotlin'),
    SkillSet(id: 7, name: 'HTML/CSS'),
  ];

  final List<SkillSet> skillsets2 = [
    SkillSet(id: 0, name: 'C'),
    SkillSet(id: 1, name: 'C++'),
    SkillSet(id: 2, name: 'C#'),
    SkillSet(id: 3, name: 'Python'),
    SkillSet(id: 4, name: 'Java'),
    SkillSet(id: 5, name: 'JavaScript'),
    SkillSet(id: 6, name: 'Kotlin'),
    SkillSet(id: 7, name: 'HTML/CSS'),
  ];

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
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            FaIcon(FontAwesomeIcons.solidUser,
                color: Color(0xffffffff), size: 24)
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Column(
              children: [
                // TEXT: Welcome
                Row(children: [
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.topCenter,
                        child: const Text(
                          'CV & Transcript',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                  ),
                ]),
                // TEXT: Guidance
                Row(children: [
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.topCenter,
                        child: const Text(
                          'Tell us about yourself and you will be your way connect with real-world projects',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        )),
                  ),
                ]),
                // Resume/CV
                Column(children: [
                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 20),
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Resume/CV (*)',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: const Wrap(
                              spacing: 8.0, // Adjust the spacing between items
                              runSpacing:
                                  8.0, // Adjust the spacing between lines
                              children: [
                                SizedBox(
                                  height: 100, // Set your desired height here
                                  child: Center(
                                    child: Text(
                                      'No resume uploaded',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  )
                ]),
                // Transcript
                Column(children: [
                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 20),
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Transcript (*)',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: const Wrap(
                              spacing: 8.0, // Adjust the spacing between items
                              runSpacing:
                                  8.0, // Adjust the spacing between lines
                              children: [
                                SizedBox(
                                  height: 100, // Set your desired height here
                                  child: Center(
                                    child: Text(
                                      'No transcript uploaded',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  )
                ]),
                // Continue button
                Container(
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(top: 20),
                  child: ButtonSimple(
                      label: 'Next',
                      onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const StudentDashboardScreen()))
                          }),
                )
              ],
            )),
      ),
    );
  }
}
