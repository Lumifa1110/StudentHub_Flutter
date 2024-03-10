import 'package:flutter/material.dart';
import 'package:studenthub/components/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/pages/index.dart';

class StudentProfileInputScreen extends StatefulWidget {
  const StudentProfileInputScreen({super.key});

  @override
  State<StudentProfileInputScreen> createState() => _StudentProfileInputScreenState();
}

class _StudentProfileInputScreenState extends State<StudentProfileInputScreen> {
  // TextField controller
  final techStackController = TextEditingController();

  late List<Skillset> studentSkillsets;

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
    
    List<String> skillsetNames = studentSkillsets.map((skillset) => skillset.name).toList();
    print('${skillsetNames.join(', ')}');
  }

  void removeSkillset(String name) {
    setState(() {
      studentSkillsets.removeWhere((skillset) => skillset.name == name);
    });
    
    List<String> skillsetNames = studentSkillsets.map((skillset) => skillset.name).toList();
    print('${skillsetNames.join(', ')}');
  }

  bool isSkillsetIncluded(String name) {
    return studentSkillsets.any((skillset) => skillset.name == name);
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
                            children: studentSkillsets.isEmpty
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
                ]
              ),
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
                  }
                ).toList(),
                ),
              ),
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