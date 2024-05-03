import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/index.dart';
import 'package:studenthub/components/profile_input/custom_textfield.dart';
import 'package:studenthub/components/profile_input/education_item.dart';
import 'package:studenthub/components/profile_input/language_item.dart';
import 'package:studenthub/components/profile_input/list_empty_box.dart';
import 'package:studenthub/models/education_model.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/models/language_model.dart';
import 'package:studenthub/models/techstack_model.dart';
import 'package:studenthub/services/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';
import 'index.dart';

class StudentProfileInputScreen1 extends StatefulWidget {
  const StudentProfileInputScreen1({super.key});

  @override
  State<StudentProfileInputScreen1> createState() => _StudentProfileInputScreen1State();
}

class _StudentProfileInputScreen1State extends State<StudentProfileInputScreen1> {
  // TextField controllers
  final fullnameController = TextEditingController();
  final techStackController = TextEditingController();
  final languageController = TextEditingController();
  final educationController = TextEditingController();
  final educationStartYearController = TextEditingController();
  final educationEndYearController = TextEditingController();

  // Techstack states
  late List<TechStack> techStacks = [];
  late int selectedTechStack = 1;

  // Skillset states
  late List<SkillSet> skillSets = [];
  final List<SkillSet> studentSelectedSkills = [];
  late Map<int, bool> isCheckedList;

  // Language states
  final List<Language> studentSelectedLanguages = [];
  late String selectedLanguageLevel;

  // Education states
  final List<Education> studentSelectedEducations = [];
  late DateTime selectedStartDate = DateTime.now();
  late DateTime selectedEndDate = DateTime.now();

  // UI handling states
  late bool isOpenLanguageInput;
  late bool isOpenEducationInput;

  final List<String> languageLevels = const [
    'Expert',
    'High',
    'Medium',
    'Low',
  ];

  @override
  void initState() {
    super.initState();
    fetchAllTechstack();
    fetchAllSkillset();
    isOpenLanguageInput = false;
    selectedLanguageLevel = 'Medium';
    isOpenEducationInput = false;
  }

  void fetchAllTechstack() async {
    final Map<String, dynamic> response = await DefaultService.getAllTechstack();
    print(response);
    setState(() {
      techStacks = response['result'].map<TechStack>((json) => TechStack.fromJson(json)).toList();
    });
  }

  void fetchAllSkillset() async {
    final Map<String, dynamic> response = await DefaultService.getAllSkillset();
    setState(() {
      skillSets = response['result'].map<SkillSet>((json) => SkillSet.fromJson(json)).toList();
      isCheckedList = {for (var skillset in skillSets) skillset.id: false};
    });
  }

  void addSelectedSkills(int id) {
    setState(() {
      if (!isSkillIncluded(id)) {
        SkillSet skill = skillSets.firstWhere((element) => element.id == id);
        studentSelectedSkills.add(skill);
        isCheckedList[id] = true;
      }
    });
  }

  void removeSelectedSkills(int id) {
    setState(() {
      studentSelectedSkills.removeWhere((skill) => skill.id == id);
      isCheckedList[id] = false;
    });
  }

  bool isSkillIncluded(int id) {
    return studentSelectedSkills.any((skillset) => skillset.id == id);
  }

  bool isNumeric(String? str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  void handleAddLanguage() {
    if (languageController.text.isNotEmpty) {
      setState(() {
        studentSelectedLanguages.add(
            Language(id: 0, languageName: languageController.text, level: selectedLanguageLevel));
      });
    }
  }

  void handleAddEducation() {
    if (educationController.text.isNotEmpty &&
        isNumeric(educationStartYearController.text) &&
        isNumeric(educationEndYearController.text)) {
      setState(() {
        studentSelectedEducations.add(Education(
            id: 0,
            schoolName: educationController.text,
            startYear: selectedStartDate,
            endYear: selectedEndDate));
      });
    }
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy').format(dateTime);
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedStartDate) {
      setState(() {
        selectedStartDate = picked;
      });
      educationStartYearController.text = formatDateTime(picked);
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedEndDate,
      firstDate: selectedStartDate,
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedEndDate) {
      setState(() {
        selectedEndDate = picked;
      });
      educationEndYearController.text = formatDateTime(picked);
    }
  }

  @override
  void dispose() {
    languageController.dispose();
    educationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // late List<bool> checkedItemList = [];
    return Scaffold(
      appBar: const AuthAppBar(canBack: true, title: 'Create student profile'),
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
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                      )),
                ),
              ]),
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 20, bottom: 12),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Full name',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              CustomTextfield(controller: fullnameController, hintText: 'Full name...'),
              // Techstack selection
              Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 20, bottom: 12),
                  alignment: Alignment.topLeft,
                  child: const Text(
                    'Techstack',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              // Techstack dropdown
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 60,
                      child: InputDecorator(
                        decoration: const InputDecoration(border: OutlineInputBorder()),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: selectedTechStack,
                            onChanged: (int? newValue) {
                              setState(() {
                                selectedTechStack = newValue!;
                              });
                            },
                            style: const TextStyle(
                                color: AppFonts.primaryColor, fontSize: AppFonts.h3FontSize),
                            items: techStacks.map<DropdownMenuItem<int>>((TechStack techStack) {
                              return DropdownMenuItem<int>(
                                value: techStack.id,
                                child: Text(techStack.name),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              // Skillset selection
              Column(children: [
                Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20, bottom: 12),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Skillset',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                        child: Wrap(
                          spacing: 8.0, // Adjust the spacing between items
                          runSpacing: 8.0, // Adjust the spacing between lines
                          children: studentSelectedSkills.isEmpty
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
                              : studentSelectedSkills.map((skillset) {
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
                height: 300, // Set a specific height,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: ListView(
                  children: skillSets.map((skillset) {
                    return SkillsetItem(
                      skillset: skillset,
                      isChecked: isCheckedList[skillset.id]!,
                      addSkillset: addSelectedSkills,
                      removeSkillset: removeSelectedSkills,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              // Languages
              Row(children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Title
                        const Expanded(
                          flex: 7,
                          child: Text(
                            'Languages',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        // Add language button
                        Expanded(
                          flex: 3,
                          child: Row(children: [
                            // Save button
                            isOpenLanguageInput
                                ? GestureDetector(
                                    onTap: () {
                                      handleAddLanguage();
                                      languageController.clear();
                                      setState(() {
                                        isOpenLanguageInput = false;
                                      });
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        width: 80,
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(
                                            color: AppColor.primary,
                                            borderRadius: BorderRadius.circular(6)),
                                        child: const Text('Save',
                                            style: TextStyle(
                                                color: Colors.white, fontWeight: FontWeight.w500))),
                                  )
                                : const SizedBox.shrink(),
                          ]),
                        ),
                        // Add button - Close button
                        Expanded(
                          flex: 3,
                          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isOpenLanguageInput = !isOpenLanguageInput;
                                });
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  width: 80,
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      color:
                                          isOpenLanguageInput ? Colors.black38 : AppColor.primary,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: !isOpenLanguageInput
                                      ? const Row(
                                          children: [
                                            Icon(Icons.add, size: 20, color: Colors.white),
                                            SizedBox(width: 10),
                                            Text('Add',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500))
                                          ],
                                        )
                                      : const Text('Close',
                                          style: TextStyle(
                                              color: Colors.white, fontWeight: FontWeight.w500))),
                            ),
                          ]),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
              // START: Input new language
              isOpenLanguageInput
                  ? Column(children: [
                      // Textfield
                      CustomTextfield(controller: languageController, hintText: 'Language name...'),
                      const SizedBox(height: 10),
                      // Language level dropdown and Save button
                      Row(children: [
                        // Dropdown
                        Expanded(
                          child: SizedBox(
                            height: 60,
                            child: InputDecorator(
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedLanguageLevel,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedLanguageLevel = newValue!;
                                    });
                                  },
                                  style: const TextStyle(
                                      color: AppFonts.primaryColor, fontSize: AppFonts.h3FontSize),
                                  items:
                                      languageLevels.map<DropdownMenuItem<String>>((String level) {
                                    return DropdownMenuItem<String>(
                                      value: level,
                                      child: Text(level),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        )
                      ]),
                    ])
                  : const SizedBox.shrink(),
              const SizedBox(height: 20),
              // END: Input new language
              // LIST: Languages
              // If list is empty
              !isOpenLanguageInput && studentSelectedLanguages.isEmpty
                  ? const ListEmptyBox()
                  : const SizedBox.shrink(),
              // List data
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: studentSelectedLanguages.length,
                  itemBuilder: (BuildContext context, int index) {
                    return LanguageItem(
                      language: studentSelectedLanguages[index],
                      handleDelete: () {
                        setState(() {
                          studentSelectedLanguages.removeAt(index);
                        });
                      },
                    );
                  }),
              const SizedBox(height: 40),
              // Education
              Row(children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Title
                        const Expanded(
                          flex: 7,
                          child: Text(
                            'Education',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        // Add education button
                        Expanded(
                          flex: 3,
                          child: Row(children: [
                            // Save button
                            isOpenEducationInput
                                ? GestureDetector(
                                    onTap: () {
                                      handleAddEducation();
                                      educationController.clear();
                                      setState(() {
                                        isOpenEducationInput = false;
                                      });
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        width: 80,
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        decoration: BoxDecoration(
                                            color: AppColor.primary,
                                            borderRadius: BorderRadius.circular(6)),
                                        child: const Text('Save',
                                            style: TextStyle(
                                                color: Colors.white, fontWeight: FontWeight.w500))),
                                  )
                                : const SizedBox.shrink(),
                          ]),
                        ),
                        // Add button - Close button
                        Expanded(
                          flex: 3,
                          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isOpenEducationInput = !isOpenEducationInput;
                                });
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  width: 80,
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                      color:
                                          isOpenEducationInput ? Colors.black38 : AppColor.primary,
                                      borderRadius: BorderRadius.circular(6)),
                                  child: !isOpenEducationInput
                                      ? const Row(
                                          children: [
                                            Icon(Icons.add, size: 20, color: Colors.white),
                                            SizedBox(width: 10),
                                            Text('Add',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w500))
                                          ],
                                        )
                                      : const Text('Close',
                                          style: TextStyle(
                                              color: Colors.white, fontWeight: FontWeight.w500))),
                            ),
                          ]),
                        )
                      ],
                    ),
                  ),
                ),
              ]),
              // START: Input new education
              isOpenEducationInput
                  ? Column(children: [
                      // Textfield
                      CustomTextfield(
                          controller: educationController, hintText: 'Education name...'),
                      const SizedBox(height: 10),
                      // Input education startYear and endYear
                      Row(children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                              onTap: () => {selectStartDate(context)},
                              child: AbsorbPointer(
                                  child: CustomTextfield(
                                      controller: educationStartYearController,
                                      hintText: 'start year'))),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                              onTap: () => {selectEndDate(context)},
                              child: AbsorbPointer(
                                  child: CustomTextfield(
                                      controller: educationEndYearController,
                                      hintText: 'end year'))),
                        )
                      ]),
                    ])
                  : const SizedBox.shrink(),
              const SizedBox(height: 20),
              // END: Input new language
              // LIST: Educations
              // If list is empty
              !isOpenEducationInput && studentSelectedEducations.isEmpty
                  ? const ListEmptyBox()
                  : const SizedBox.shrink(),
              // List data
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: studentSelectedEducations.length,
                  itemBuilder: (BuildContext context, int index) {
                    return EducationItem(
                      education: studentSelectedEducations[index],
                      handleDelete: () {
                        setState(() {
                          studentSelectedEducations.removeAt(index);
                        });
                      },
                    );
                  }),
              // Continue button
              const SizedBox(height: 60),
              Row(
                children: [
                  Expanded(
                    child: ButtonSimple(
                      label: 'Next',
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentProfileInputScreen2(
                              studentFullname: fullnameController.text,
                              studentTechstack: selectedTechStack,
                              studentSkillsets: studentSelectedSkills,
                              studentLanguages: studentSelectedLanguages,
                              studentEducations: studentSelectedEducations,
                            ),
                          ),
                        )
                      },
                      isButtonEnabled: true,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
