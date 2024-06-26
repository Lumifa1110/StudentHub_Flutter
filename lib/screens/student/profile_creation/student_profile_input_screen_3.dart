// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/components/profile_input/file_item.dart';
import 'package:studenthub/models/education_model.dart';
import 'package:studenthub/models/experience_model.dart';
import 'package:studenthub/models/language_model.dart';
import 'package:studenthub/models/skillset_model.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/services/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';

class StudentProfileInputScreen3 extends StatefulWidget {
  final String studentFullname;
  final int studentTechstack;
  final List<SkillSet> studentSkillsets;
  final List<Language> studentLanguages;
  final List<Education> studentEducations;
  final List<Experience> studentExperiences;

  const StudentProfileInputScreen3({
    super.key,
    required this.studentFullname,
    required this.studentTechstack,
    required this.studentSkillsets,
    required this.studentLanguages,
    required this.studentEducations,
    required this.studentExperiences,
  });

  @override
  State<StudentProfileInputScreen3> createState() => _StudentProfileInputScreen3State();
}

class _StudentProfileInputScreen3State extends State<StudentProfileInputScreen3> {
  final String baseUrl = 'https://api.studenthub.dev';
  late PlatformFile resumeFile;
  late PlatformFile transcriptFile;

  bool resumeFilePicked = false;
  bool transcriptFilePicked = false;

  String formatDateTime(DateTime dateTime) {
    final result = DateFormat('mm-yyyy').format(dateTime);
    return result;
  }

  Future<void> openResumeFilePicker(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'docx'],
      );
      if (result != null) {
        resumeFile = result.files.first;
        setState(() {
          resumeFilePicked = true;
        });
      }
    } catch (e) {
      print('Error picking resume file: $e');
    }
  }

  Future<void> openTranscriptFilePicker(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'docx'],
      );
      if (result != null) {
        transcriptFile = result.files.first;
        setState(() {
          transcriptFilePicked = true;
        });
      }
    } catch (e) {
      print('Error picking transcript file: $e');
    }
  }

  Future<void> handleUploadResume() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final studentProfile = prefs.getString('student_profile');
    final studentId = jsonDecode(studentProfile!)['id'];
    // Declare request
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('$baseUrl/api/profile/student/$studentId/resume'),
    );
    // Add header to the request
    request.headers['Authorization'] = 'Bearer $token';
    // Add the file to the request
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        resumeFile.path!,
      ),
    );
    // Check the response and handle accordingly
    var response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('File uploaded successfully');
    } else {
      print('Error uploading resume file: ${response.statusCode}');
    }
  }

  Future<void> handleUploadTranscript() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final studentProfile = prefs.getString('student_profile');
    final studentId = jsonDecode(studentProfile!)['id'];
    // Declare request
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('$baseUrl/api/profile/student/$studentId/transcript'),
    );
    // Add header to the request
    request.headers['Authorization'] = 'Bearer $token';
    // Add the file to the request
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        transcriptFile.path!,
      ),
    );
    // Check the response and handle accordingly
    var response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('File uploaded successfully');
    } else {
      print('Error uploading transcript file: ${response.statusCode}');
    }
  }

  Future<void> handlePostProfile(BuildContext context) async {
    await StudentService.addStudentProfile({
      "techStackId": widget.studentTechstack.toString(),
      "skillSets": widget.studentSkillsets.map((skillset) => skillset.id).toList()
    });
  }

  Future<void> handleSubmitProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final studentProfile = prefs.getString('student_profile');
    final String studentId;

    // IF student profile is empty -> create student profile
    if (studentProfile == 'null') {
      final Map<String, dynamic> studentProfileResponse = await StudentService.addStudentProfile({
        "techStackId": widget.studentTechstack.toString(),
        "skillSets": widget.studentSkillsets.map((skillset) => skillset.id).toList()
      });
      print(studentProfileResponse);
      await prefs.setString('student_profile', jsonEncode(studentProfileResponse));
      studentId = studentProfileResponse['result']['id'].toString();
    } else {
      studentId = jsonDecode(studentProfile!)['id'].toString();
    }
    // GET: student profile id

    // API: update student profile
    await StudentService.updateStudentProfile(studentId, {
      "techStackId": widget.studentTechstack.toString(),
      "skillSets": widget.studentSkillsets.map((skillset) => skillset.id).toList()
    });
    await StudentService.addStudentLanguage(studentId, {
      "languages": widget.studentLanguages
          .map((language) => {"languageName": language.languageName, "level": language.level})
          .toList()
    });
    await StudentService.addStudentEducation(studentId, {
      "education": widget.studentEducations
          .map((education) => {
                "schoolName": education.schoolName,
                "startYear": education.startYear.year,
                "endYear": education.endYear!.year
              })
          .toList()
    });
    await StudentService.addStudentExperience(studentId, {
      "experience": widget.studentExperiences
          .map((experience) => {
                "title": experience.title,
                "startMonth": experience.startMonth,
                "endMonth": experience.endMonth,
                "description": experience.description,
                "skillSets": ["1", "2"]
              })
          .toList()
    });
    await handleUploadResume();
    await handleUploadTranscript();
    // SAVE LOCAL: student profile
    final Map<String, dynamic> userInfo = await AuthService.getUserInfo();
    final newStudentProfile = userInfo['result']['student'];
    await prefs.setString('student_profile', jsonEncode(newStudentProfile));

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const StudentDashboardScreen()),
      );
    }
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
                          'CV & Transcript',
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
                // Resume/CV
                Column(
                  children: [
                    Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 20),
                        alignment: Alignment.topLeft,
                        child: const Text(
                          'Resume/CV (*)',
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => {openResumeFilePicker(context)},
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              padding: const EdgeInsets.all(6),
                              decoration:
                                  BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                              child: const Wrap(
                                spacing: 8.0,
                                runSpacing: 8.0,
                                children: [
                                  SizedBox(
                                    height: 100,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          FaIcon(FontAwesomeIcons.upload,
                                              size: 30, color: AppColor.primary),
                                          SizedBox(height: 10),
                                          Text(
                                            'Upload resume here',
                                            style: TextStyle(
                                                color: AppFonts.primaryColor,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                // Show picked resume file
                resumeFilePicked
                    ? PickedFileItem(filename: resumeFile.name)
                    : const SizedBox.shrink(),
                const SizedBox(height: 20),
                // Transcript
                Column(children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 20),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'Transcript (*)',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => {openTranscriptFilePicker(context)},
                          child: Container(
                            margin: const EdgeInsets.only(top: 20),
                            padding: const EdgeInsets.all(6),
                            decoration:
                                BoxDecoration(border: Border.all(color: Colors.grey, width: 1)),
                            child: const Wrap(spacing: 8.0, runSpacing: 8.0, children: [
                              SizedBox(
                                height: 100,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      FaIcon(FontAwesomeIcons.upload,
                                          size: 30, color: AppColor.primary),
                                      SizedBox(height: 10),
                                      Text(
                                        'Upload transcript here',
                                        style: TextStyle(
                                            color: AppFonts.primaryColor,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
                // Show picked transcript file
                transcriptFilePicked
                    ? PickedFileItem(filename: transcriptFile.name)
                    : const SizedBox.shrink(),
                // Continue button
                Container(
                  alignment: Alignment.bottomRight,
                  margin: const EdgeInsets.only(top: 20),
                  child: ButtonSimple(
                    label: 'Continue',
                    onPressed: () => {
                      handleSubmitProfile(),
                    },
                    isButtonEnabled: resumeFilePicked && transcriptFilePicked,
                  ),
                )
              ],
            )),
      ),
    );
  }
}
