import 'package:flutter/material.dart';
import 'package:studenthub/components/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/models/index.dart';

import 'index.dart';

class StudentProfileInputScreen2 extends StatefulWidget {
  final List<SkillSet> studentSkillsets;

  const StudentProfileInputScreen2({super.key, required this.studentSkillsets});

  @override
  State<StudentProfileInputScreen2> createState() =>
      _StudentProfileInputScreen2State();
}

class _StudentProfileInputScreen2State
    extends State<StudentProfileInputScreen2> {
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

  void removeSelectedSkills(int id) {
    setState(() {});
  }

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
                          'Experiences',
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
                // START: Project 1
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.topCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Projects',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            // Languages control button
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 16.0,
                                      child: IconButton(
                                        icon: const Icon(Icons.add, size: 16),
                                        onPressed: () {
                                          // Handle the edit button press
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 16.0,
                                      child: IconButton(
                                        icon: const Icon(Icons.edit, size: 16),
                                        onPressed: () {
                                          // Handle the edit button press
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(children: [
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 10),
                        alignment: Alignment.topLeft,
                        child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Project Management Web Application',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                '1/2024 - 5/2024, 4 months\n',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ])),
                  ),
                ]),
                // Project description
                Row(children: [
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.topCenter,
                        child: const Text(
                          'It is the developer of an app that replicates Trello: a streamlined project management with visual boards, lists, and cards for easy collaboration and task tracking.',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        )),
                  ),
                ]),
                // Skillset selection
                Column(children: [
                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 20),
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Skillset',
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
                          child: Wrap(
                            spacing: 8.0, // Adjust the spacing between items
                            runSpacing: 8.0, // Adjust the spacing between lines
                            children: widget.toStringShallow().isEmpty
                                ? [
                                    const SizedBox(
                                      height:
                                          100, // Set your desired height here
                                      child: Center(
                                        child: Text(
                                          'No skillsets selected',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ]
                                : skillsets1.map((skillset) {
                                    return BoxSkillset(
                                      text: skillset.name,
                                      id: skillset.id,
                                      onDelete: removeSelectedSkills,
                                    );
                                  }).toList(),
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
                // Divider
                Container(
                  margin: const EdgeInsets.only(
                      top: 30, bottom: 10), // Adjust the margin as needed
                  child: const Divider(
                    thickness: 2, // Adjust the thickness as needed
                  ),
                ),
                // START: Project 2
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.topCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Projects',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            // Languages control button
                            Row(
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 16.0,
                                      child: IconButton(
                                        icon: const Icon(Icons.add, size: 16),
                                        onPressed: () {
                                          // Handle the edit button press
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.black, width: 2.0),
                                  ),
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 16.0,
                                      child: IconButton(
                                        icon: const Icon(Icons.edit, size: 16),
                                        onPressed: () {
                                          // Handle the edit button press
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(children: [
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 10),
                        alignment: Alignment.topLeft,
                        child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Student Hub',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                '1/2024 - 5/2024, 4 months\n',
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400),
                              ),
                            ])),
                  ),
                ]),
                // Project description
                Row(children: [
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.topCenter,
                        child: const Text(
                          'It is the developer of an app that help students apply for real-world company projects.',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        )),
                  ),
                ]),
                // Skillset selection
                Column(children: [
                  Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 20),
                      alignment: Alignment.topLeft,
                      child: const Text(
                        'Skillset',
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
                          child: Wrap(
                            spacing: 8.0, // Adjust the spacing between items
                            runSpacing: 8.0, // Adjust the spacing between lines
                            children: widget.toStringShallow().isEmpty
                                ? [
                                    const SizedBox(
                                      height:
                                          100, // Set your desired height here
                                      child: Center(
                                        child: Text(
                                          'No skillsets selected',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ]
                                : skillsets2.map((skillset) {
                                    return BoxSkillset(
                                      text: skillset.name,
                                      id: skillset.id,
                                      onDelete: removeSelectedSkills,
                                    );
                                  }).toList(),
                          ),
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
                                        StudentProfileInputScreen3()))
                          }),
                )
              ],
            )),
      ),
    );
  }
}
