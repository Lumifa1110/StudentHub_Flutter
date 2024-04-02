import 'package:flutter/material.dart';
import 'package:studenthub/components/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/models/index.dart';

class StudentSelectSkillsetScreen extends StatefulWidget {
  final List<Skillset> studentSkillsets;
  final Function(String) addSkillset;
  final Function(String) removeSkillset;

  const StudentSelectSkillsetScreen({
    super.key, 
    required this.studentSkillsets,
    required this.addSkillset,
    required this.removeSkillset
  });

  @override
  State<StudentSelectSkillsetScreen> createState() => _StudentSelectSkillsetScreenState();
}

class _StudentSelectSkillsetScreenState extends State<StudentSelectSkillsetScreen> {
  final List<Skillset> skillsets =  [
    Skillset('AWS'),
    Skillset('ReactJS'),
    Skillset('Flutter'),
    Skillset('NodeJS'),
    Skillset('Android Development'),
    Skillset('IOS Development'),
    Skillset('MongoDB'),
    Skillset('Git')
  ];

  bool isSkillsetIncluded(String name) {
    return widget.studentSkillsets.any((skillset) => skillset.name == name);
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
              const SizedBox(
                height: 20,
              ),
              // Skillset selection
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Skillset',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal
                      ),
                    )
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1
                            )
                          ),
                          child: Wrap(
                            spacing: 8.0, // Adjust the spacing between items
                            runSpacing: 8.0, // Adjust the spacing between lines
                            children: widget.studentSkillsets.isEmpty
                              ? [
                                  const SizedBox(
                                    height: 100, // Set your desired height here
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
                                    text: skillset.name,
                                    onDelete: () {
                                      
                                    },
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ],
                  )
                ]
              ),
              Container(
                height: 400, // Set a specific height,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: ListView(
                  children: skillsets.map((skillset) {
                    return ListTileSkillset(
                      itemName: skillset.name,
                      isChecked: isSkillsetIncluded(skillset.name),
                      addSkillset: widget.addSkillset,
                      removeSkillset: widget.removeSkillset,
                    );
                  }
                ).toList(),
                ),
              ),
              // Continue button
              Container(
                alignment: Alignment.bottomRight,
                margin: const EdgeInsets.only(top: 20),
                child: ButtonSimple(
                  label: 'Save', 
                  onPressed: () => {
                    Navigator.pushNamed(context, '/student/profile')
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