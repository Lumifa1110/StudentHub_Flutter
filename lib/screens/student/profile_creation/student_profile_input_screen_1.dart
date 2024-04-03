import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/models/index.dart';

import 'index.dart';

class StudentProfileInputScreen1 extends StatefulWidget {
  const StudentProfileInputScreen1({super.key});

  @override
  State<StudentProfileInputScreen1> createState() =>
      _StudentProfileInputScreen1State();
}

class _StudentProfileInputScreen1State
    extends State<StudentProfileInputScreen1> {
  // TextField controller
  final techStackController = TextEditingController();

  late List<Skillset> studentSkillsets;

  final List<Skillset> skillsets = [
    Skillset('AWS'),
    Skillset('ReactJS'),
    Skillset('Flutter'),
    Skillset('NodeJS'),
    Skillset('Android Development'),
    Skillset('IOS Development'),
    Skillset('MongoDB'),
    Skillset('Git')
  ];

  @override
  void initState() {
    super.initState();
    studentSkillsets = [];
  }

  void addSkillset(String name) {
    setState(() {
      Skillset newSkillset = Skillset(name);
      studentSkillsets.add(newSkillset);
    });
  }

  void removeSkillset(String name) {
    setState(() {
      studentSkillsets.removeWhere((skillset) => skillset.name == name);
    });
  }

  bool isSkillsetIncluded(String name) {
    return studentSkillsets.any((skillset) => skillset.name == name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(canBack: false),
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
                          'Welcome to Student Hub!',
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
                // TextFields
                TextFieldWithLabel(
                    label: 'Techstack',
                    controller: techStackController,
                    lineCount: 1),
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
                            children: studentSkillsets.isEmpty
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
                                : studentSkillsets.map((skillset) {
                                    return BoxSkillset(
                                      text: skillset.name,
                                      onDelete: () {
                                        removeSkillset(skillset.name);
                                      },
                                    );
                                  }).toList(),
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
                Container(
                  height: 300, // Set a specific height,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: ListView(
                    children: skillsets.map((skillset) {
                      return ListTileSkillset(
                        itemName: skillset.name,
                        isChecked: isSkillsetIncluded(skillset.name),
                        addSkillset: addSkillset,
                        removeSkillset: removeSkillset,
                      );
                    }).toList(),
                  ),
                ),
                // Divider
                Container(
                  margin: const EdgeInsets.only(
                      top: 30, bottom: 10), // Adjust the margin as needed
                  child: const Divider(
                    thickness: 2, // Adjust the thickness as needed
                  ),
                ),
                // Languages
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
                              'Languages',
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
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Vietnamese: Native\nEnglish: Bilingual',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        )),
                  ),
                ]),
                // Education
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
                              'Languages',
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
                        child: const Text(
                          'Tran Dai Nghia highschool for the gifted\n2013-2020',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        )),
                  ),
                ]),
                Row(children: [
                  Expanded(
                    child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 10),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Ho Chi Minh University of Science\n2020-2024',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.normal),
                        )),
                  ),
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
                                        StudentProfileInputScreen2(
                                          studentSkillsets: studentSkillsets,
                                        )))
                          }),
                )
              ],
            )),
      ),
    );
  }
}
