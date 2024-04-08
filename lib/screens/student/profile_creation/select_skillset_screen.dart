import 'package:flutter/material.dart';
import 'package:studenthub/components/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/models/index.dart';

class StudentSelectSkillsetScreen extends StatefulWidget {
  final List<SkillSet> studentSkillsets;
  final Function(int) addSkillset;
  final Function(int) removeSkillset;

  const StudentSelectSkillsetScreen(
      {super.key,
      required this.studentSkillsets,
      required this.addSkillset,
      required this.removeSkillset});

  @override
  State<StudentSelectSkillsetScreen> createState() =>
      _StudentSelectSkillsetScreenState();
}

class _StudentSelectSkillsetScreenState
    extends State<StudentSelectSkillsetScreen> {
  final List<SkillSet> skillsets = [
    SkillSet(id: 0, name: 'C'),
    SkillSet(id: 1, name: 'C++'),
    SkillSet(id: 2, name: 'C#'),
    SkillSet(id: 3, name: 'Python'),
    SkillSet(id: 4, name: 'Java'),
    SkillSet(id: 5, name: 'JavaScript'),
    SkillSet(id: 6, name: 'Kotlin'),
    SkillSet(id: 7, name: 'HTML/CSS'),
  ];

  bool isSkillsetIncluded(String name) {
    return widget.studentSkillsets.any((skillset) => skillset.name == name);
  }

  void removeSelectedSkills(int id) {}

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
                const SizedBox(
                  height: 20,
                ),
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
                            fontSize: 16, fontWeight: FontWeight.normal),
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
                            children: widget.studentSkillsets.isEmpty
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
                                : widget.studentSkillsets.map((skillset) {
                                    return BoxSkillset(
                                      id: skillset.id,
                                      text: skillset.name,
                                      onDelete: removeSelectedSkills,
                                    );
                                  }).toList(),
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
                Container(
                  height: 400, // Set a specific height,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: ListView(
                    children: skillsets.map((skillset) {
                      return ListTileSkillset(
                        itemName: skillset.name,
                        itemId: skillset.id,
                        isChecked: isSkillsetIncluded(skillset.name),
                        addSkillset: widget.addSkillset,
                        removeSkillset: widget.removeSkillset,
                      );
                    }).toList(),
                  ),
                ),
                // Continue button
                Container(
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(top: 20),
                  child: ButtonSimple(
                      label: 'Save',
                      onPressed: () =>
                          {Navigator.pushNamed(context, '/student/profile')}),
                )
              ],
            )),
      ),
    );
  }
}
