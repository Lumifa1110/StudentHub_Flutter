import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/index.dart';
import 'package:studenthub/components/profile_input/custom_textarea.dart';
import 'package:studenthub/components/profile_input/custom_textfield.dart';
import 'package:studenthub/components/profile_input/experience_item.dart';
import 'package:studenthub/components/profile_input/list_empty_box.dart';
import 'package:studenthub/models/education_model.dart';
import 'package:studenthub/models/experience_model.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/models/language_model.dart';
import 'package:studenthub/services/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

import 'index.dart';

class StudentProfileInputScreen2 extends StatefulWidget {
  final String studentFullname;
  final int studentTechstack;
  final List<SkillSet> studentSkillsets;
  final List<Language> studentLanguages;
  final List<Education> studentEducations;

  const StudentProfileInputScreen2(
      {super.key,
      required this.studentFullname,
      required this.studentTechstack,
      required this.studentSkillsets,
      required this.studentLanguages,
      required this.studentEducations});

  @override
  State<StudentProfileInputScreen2> createState() =>
      _StudentProfileInputScreen2State();
}

class _StudentProfileInputScreen2State
    extends State<StudentProfileInputScreen2> {
  // TextField controller
  final TextEditingController experienceTitleController =
      TextEditingController();
  final TextEditingController experienceStartYearController =
      TextEditingController();
  final TextEditingController experienceEndYearController =
      TextEditingController();
  final TextEditingController experienceDescriptionController =
      TextEditingController();

  // Experience
  final List<Experience> studentSelectedExperiences = [];
  late DateTime selectedStartDate = DateTime.now();
  late DateTime selectedEndDate = DateTime.now();

  // UI states
  late bool isOpenExperienceInput;

  // Skillset states
  late List<SkillSet> skillSets = [];
  final List<SkillSet> selectedSkillsets = [];
  late Map<int, bool> isCheckedList;

  void fetchAllSkillset() async {
    final Map<String, dynamic> response = await DefaultService.getAllSkillset();
    setState(() {
      skillSets = response['result']
          .map<SkillSet>((json) => SkillSet.fromJson(json))
          .toList();
      isCheckedList = {for (var skillset in skillSets) skillset.id: false};
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAllSkillset();
    isOpenExperienceInput = false;
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('MMMM - yyyy').format(dateTime);
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
      experienceStartYearController.text = formatDateTime(picked);
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
      experienceEndYearController.text = formatDateTime(picked);
    }
  }

  void addSelectedSkills(int id) {
    setState(() {
      if (!isSkillIncluded(id)) {
        SkillSet skill = skillSets.firstWhere((element) => element.id == id);
        selectedSkillsets.add(skill);
        isCheckedList[id] = true;
      }
    });
  }

  void removeSelectedSkills(int id) {
    setState(() {
      selectedSkillsets.removeWhere((skill) => skill.id == id);
      isCheckedList[id] = false;
    });
  }

  bool isSkillIncluded(int id) {
    return selectedSkillsets.any((skillset) => skillset.id == id);
  }

  void handleAddExperience() {
    List<SkillSet> selectedSkillsetsData =
        List<SkillSet>.from(selectedSkillsets);
    String startMonthFormatted =
        DateFormat('MM-yyyy').format(selectedStartDate);
    String endMonthFormatted = DateFormat('MM-yyyy').format(selectedEndDate);
    setState(() {
      studentSelectedExperiences.add(Experience(
          id: 0,
          title: experienceTitleController.text,
          startMonth: startMonthFormatted,
          endMonth: endMonthFormatted,
          description: experienceDescriptionController.text,
          skillsets: selectedSkillsetsData));
    });
  }

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(height: 20),
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
                              'Experiences',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          // Add education button
                          Expanded(
                            flex: 3,
                            child: Row(children: [
                              // Save button
                              isOpenExperienceInput
                                  ? GestureDetector(
                                      onTap: () {
                                        handleAddExperience();
                                        experienceTitleController.clear();
                                        setState(() {
                                          isOpenExperienceInput = false;
                                        });
                                      },
                                      child: Container(
                                          alignment: Alignment.center,
                                          width: 80,
                                          height: 40,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          decoration: BoxDecoration(
                                              color: AppColor.primary,
                                              borderRadius:
                                                  BorderRadius.circular(6)),
                                          child: const Text('Save',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                    )
                                  : const SizedBox.shrink(),
                            ]),
                          ),
                          // Add button - Close button
                          Expanded(
                            flex: 3,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isOpenExperienceInput =
                                            !isOpenExperienceInput;
                                      });
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        width: 80,
                                        height: 40,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: BoxDecoration(
                                            color: isOpenExperienceInput
                                                ? Colors.black38
                                                : AppColor.primary,
                                            borderRadius:
                                                BorderRadius.circular(6)),
                                        child: !isOpenExperienceInput
                                            ? const Row(
                                                children: [
                                                  Icon(Icons.add,
                                                      size: 20,
                                                      color: Colors.white),
                                                  SizedBox(width: 10),
                                                  Text('Add',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500))
                                                ],
                                              )
                                            : const Text('Close',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                  ),
                                ]),
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
                // START: Input new education
                isOpenExperienceInput
                    ? Column(children: [
                        // Input experience title
                        CustomTextfield(
                            controller: experienceTitleController,
                            hintText: 'Title...'),
                        const SizedBox(height: 10),
                        // Input experience startYear and endYear
                        Row(children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                                onTap: () => {selectStartDate(context)},
                                child: AbsorbPointer(
                                    child: CustomTextfield(
                                        controller:
                                            experienceStartYearController,
                                        hintText: 'start month'))),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                                onTap: () => {selectEndDate(context)},
                                child: AbsorbPointer(
                                    child: CustomTextfield(
                                        controller: experienceEndYearController,
                                        hintText: 'end month'))),
                          )
                        ]),
                        const SizedBox(height: 10),
                        // Input experience description
                        CustomTextarea(
                            controller: experienceDescriptionController,
                            hintText: 'Description...',
                            maxLines: 4),
                        // Skillset selection
                        Column(children: [
                          Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.only(top: 20, bottom: 12),
                              alignment: Alignment.topLeft,
                              child: const Text(
                                'Experience skillset',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: AppFonts.h3FontSize,
                                    fontWeight: FontWeight.bold),
                              )),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1)),
                                  child: Wrap(
                                    spacing:
                                        8.0, // Adjust the spacing between items
                                    runSpacing:
                                        8.0, // Adjust the spacing between lines
                                    children: selectedSkillsets.isEmpty
                                        ? [
                                            const SizedBox(
                                              height:
                                                  100, // Set your desired height here
                                              child: Center(
                                                child: Text(
                                                  'No skillsets selected',
                                                  style: TextStyle(
                                                      color: Colors.grey),
                                                ),
                                              ),
                                            ),
                                          ]
                                        : selectedSkillsets.map((skillset) {
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
                      ])
                    : const SizedBox.shrink(),
                const SizedBox(height: 20),
                // END: Input new language
                // LIST: Educations
                // If list is empty
                !isOpenExperienceInput && studentSelectedExperiences.isEmpty
                    ? const ListEmptyBox()
                    : const SizedBox.shrink(),
                // List data
                ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: studentSelectedExperiences.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ExperienceItem(
                          experience: studentSelectedExperiences[index]);
                    }),
                // Continue button
                const SizedBox(height: 60),
                Row(children: [
                  Expanded(
                    child: ButtonSimple(
                        label: 'Next',
                        onPressed: () => {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          StudentProfileInputScreen3(
                                            studentFullname:
                                                widget.studentFullname,
                                            studentTechstack:
                                                widget.studentTechstack,
                                            studentSkillsets:
                                                widget.studentSkillsets,
                                            studentLanguages:
                                                widget.studentLanguages,
                                            studentEducations:
                                                widget.studentEducations,
                                            studentExperiences:
                                                studentSelectedExperiences,
                                          )))
                            }),
                  ),
                ])
              ],
            )),
      ),
    );
  }
}
