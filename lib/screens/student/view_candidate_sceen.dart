import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/index.dart';
import 'package:studenthub/config/config.dart';
import 'package:studenthub/models/education_model.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

import 'package:http/http.dart' as http;

class ViewCandidateSceen extends StatefulWidget {
  final int? candidateId;

  const ViewCandidateSceen({super.key, this.candidateId});

  @override
  _ViewCandidateSceenState createState() => _ViewCandidateSceenState();
}

class _ViewCandidateSceenState extends State<ViewCandidateSceen> {
  late String candidateName = 'Luu Minh Phat';
  late String candidateTechStack = 'Fullstack Developer';
  final List<SkillSet> studentSelectedSkills = [
    SkillSet(id: 1, name: 'C'),
    SkillSet(id: 2, name: 'C++'),
    SkillSet(id: 3, name: 'C#'),
    SkillSet(id: 3, name: 'JavaScript'),
  ];
  final List<Education> studentSelectedEducations = [
    Education(
      id: 1,
      schoolName: 'University A',
      startYear: DateTime(2018),
      endYear: DateTime(2022),
      updatedAt: DateTime(2023, 5, 15),
      deletedAt: null,
    ),
    Education(
      id: 2,
      schoolName: 'College B',
      startYear: DateTime(2015),
      endYear: null,
      updatedAt: DateTime(2023, 6, 20),
      deletedAt: null,
    ),
    Education(
      id: 3,
      schoolName: 'High School C',
      startYear: DateTime(2010),
      endYear: DateTime(2015),
      updatedAt: DateTime(2023, 7, 10),
      deletedAt: DateTime(2023, 12, 31),
    ),
  ];
  String? _linkResume;
  String? _linkTranscript;

  late Map<int, bool> isCheckedList;

  Future<void> _downloadFile() async {
    final prefs = await SharedPreferences.getInstance();
    String dir = (await getApplicationDocumentsDirectory()).path;
    final token = prefs.getString('token');
    final studentProfile = prefs.getString('student_profile');
    final studentId = jsonDecode(studentProfile!)['id'];
    try {
      var response = await http.get(
        Uri.parse('$uriBase/api/profile/student/$studentId/resume'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  String getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length == 1) {
      return nameParts[0].substring(0, 1).toUpperCase();
    } else {
      String firstInitial = nameParts[0].substring(0, 1).toUpperCase();
      String lastInitial = nameParts[nameParts.length - 1].substring(0, 1).toUpperCase();
      return '$firstInitial$lastInitial';
    }
  }

  void removeSelectedSkills(int id) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteTextColor,
      appBar: const AuthAppBar(
        canBack: true,
        isShowIcon: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: mainColor,
                  ),
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: blackTextColor,
                          child: Text(
                            getInitials(candidateName),
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: AppColor.tertiary,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 8,
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                candidateName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    fontSize: AppFonts.h1FontSize,
                                    fontWeight: FontWeight.bold,
                                    color: whiteTextColor),
                              ),
                              Text(
                                candidateTechStack,
                                style: TextStyle(
                                  fontSize: AppFonts.h1_2FontSize,
                                  fontWeight: FontWeight.w500,
                                  color: lightestgrayColor.withOpacity(0.8),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Education',
                  style: TextStyle(
                      fontSize: AppFonts.h1_2FontSize,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: mainColor,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: studentSelectedEducations.isEmpty
                        ? [
                            const Text(
                              'No education is provided',
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: AppFonts.h3FontSize,
                                  fontWeight: FontWeight.w500,
                                  color: whiteTextColor),
                            ),
                          ]
                        : studentSelectedEducations.map((edu) {
                            return Text(
                              '${edu.startYear.year} - ${edu.endYear != null ? edu.endYear!.year : 'On going'}: \t ${edu.schoolName}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: AppFonts.h3FontSize,
                                  fontWeight: FontWeight.w500,
                                  color: whiteTextColor),
                            );
                          }).toList(),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'SkillSet',
                  style: TextStyle(
                      fontSize: AppFonts.h1_2FontSize,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          border: Border.all(color: mainColor, width: 1),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Wrap(
                          spacing: 8.0, // Adjust the spacing between items
                          runSpacing: 8.0, // Adjust the spacing between lines
                          children: studentSelectedSkills.isEmpty
                              ? [
                                  const SizedBox(
                                    height: 50, // Set your desired height here
                                    child: Center(
                                      child: Text(
                                        'No skill is selected',
                                        style: TextStyle(
                                            color: blackTextColor, fontSize: AppFonts.h3FontSize),
                                      ),
                                    ),
                                  ),
                                ]
                              : studentSelectedSkills.map((skillset) {
                                  return BoxSkillset(
                                    id: skillset.id,
                                    text: skillset.name,
                                    onDelete: removeSelectedSkills,
                                    hideDelete: true,
                                  );
                                }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Download Files',
                  style: TextStyle(
                      fontSize: AppFonts.h1_2FontSize,
                      fontWeight: FontWeight.bold,
                      color: mainColor),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          _linkResume == "" ? Icons.download : Icons.file_download_off,
                          color: whiteTextColor,
                        ),
                        label: const Text(
                          'Resume',
                          style: TextStyle(color: whiteTextColor, fontSize: AppFonts.h3FontSize),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(mainColor),
                          // Kích thước của nút
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(
                          _linkTranscript == "" ? Icons.download : Icons.file_download_off,
                          color: whiteTextColor,
                        ),
                        label: const Text(
                          'Transcript',
                          style: TextStyle(color: whiteTextColor, fontSize: AppFonts.h3FontSize),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(mainColor),
                          // Kích thước của nút
                        ),
                      ),
                    )
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
