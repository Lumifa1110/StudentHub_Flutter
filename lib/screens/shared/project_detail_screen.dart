import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/config/config.dart';
import 'package:studenthub/models/company_model.dart';
import 'package:studenthub/utils/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:studenthub/utils/font.dart';

import '../student/submit_proposal_page.dart';

class ProjectDetailScreen extends StatefulWidget {
  final Project? project;

  const ProjectDetailScreen({
    Key? key,
    this.project,
  }) : super(key: key);

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late SharedPreferences _prefs;
  Project? selectedProject;
  bool isStudent = true;

  @override
  void initState() {
    super.initState();
    _loadScreen();
    // fetchProjectDetails(widget.itemId);
    selectedProject = widget.project;
  }

  Future<void> _loadScreen() async {
    _prefs = await SharedPreferences.getInstance();
    final role = _prefs.getInt('current_role');
    if (role == 1) {
      setState(() {
        isStudent = false;
      });
    } else {
      setState(() {
        isStudent = true;
      });
    }
  }

  Future<void> fetchProjectDetails(int? projectId) async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse('$uriBase/api/project/$projectId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        setState(() {
          selectedProject =
              Project.fromJson(jsonDecode(response.body)['result']);
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String checkProjectScope(int? scope) {
    switch (scope) {
      case 0:
        return 'less than 1 month';
      case 1:
        return '1 To 3 months';
      case 2:
        return '3 To 6 months';
      case 3:
        return 'more than 6 months';
      default:
        return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fetch project details based on the itemId and display them

    return Scaffold(
      appBar: const AuthAppBar(
        canBack: true,
        title: 'Detail Project',
      ),
      body: selectedProject != null
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: const Text.rich(
                      TextSpan(text: 'Project detail'),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: blackTextColor,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Text(
                      selectedProject!.title,
                      style: const TextStyle(
                        fontSize: AppFonts.h1FontSize,
                        fontWeight: FontWeight.w900,
                        color: AppColor.tertiary,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      selectedProject!.companyName!,
                      style: TextStyle(
                        fontSize: AppFonts.h1_2FontSize,
                        fontWeight: FontWeight.w900,
                        color: blackTextColor.withOpacity(0.5),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1.0,
                    thickness: 2.0,
                    color: blackTextColor,
                  ),
                  Container(
                    height: 339,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: SingleChildScrollView(
                      child: Text(
                        selectedProject!.description!,
                        style: const TextStyle(
                          fontSize: AppFonts.h3FontSize,
                        ),
                      ),
                    ),
                  ),
                  const Divider(
                    height: 1.0,
                    thickness: 2.0,
                    color: blackTextColor,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListTile(
                      leading: const Icon(Icons.alarm, size: 42),
                      contentPadding: const EdgeInsets.all(0),
                      title: const Text(
                        "Project scope",
                        style: TextStyle(
                          fontSize: AppFonts.h2FontSize,
                          fontWeight: FontWeight.bold,
                          color: blackTextColor,
                        ),
                      ),
                      subtitle: Text(
                        '\t\t\t\t\t-\t${checkProjectScope(selectedProject!.projectScopeFlag)}',
                        style: const TextStyle(
                          fontSize: AppFonts.h3FontSize,
                          color: lightgrayColor,
                        ),
                      ),
                      dense: true,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: ListTile(
                      leading: const FaIcon(
                        FontAwesomeIcons.peopleGroup,
                        size: 36,
                      ),
                      contentPadding: const EdgeInsets.all(0),
                      title: const Text(
                        "Student requires",
                        style: TextStyle(
                          fontSize: AppFonts.h2FontSize,
                          fontWeight: FontWeight.bold,
                          color: blackTextColor,
                        ),
                      ),
                      subtitle: Text(
                        '\t\t\t\t\t-\t${selectedProject!.numberOfStudents} ${selectedProject!.numberOfStudents == 1 ? 'student' : 'students'}',
                        style: const TextStyle(
                          fontSize: AppFonts.h3FontSize,
                          color: lightgrayColor,
                        ),
                      ),
                      dense: true,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      isStudent
                          ? Container(
                              width: 180,
                              height: 40,
                              padding: const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: blackTextColor, width: 2.0),
                                color: whiteTextColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: blackTextColor,
                                    offset: Offset(2, 3),
                                  ),
                                ],
                              ),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SubmitProposalScreen(
                                        idProject: selectedProject?.projectId,
                                      ),
                                    ),
                                  );
                                },
                                style: ButtonStyle(
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero),
                                  ),
                                ),
                                child: const Text(
                                  'Apply now',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: blackTextColor,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      isStudent
                          ? Container(
                              width: 180,
                              height: 40,
                              padding: const EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: blackTextColor, width: 2.0),
                                color: whiteTextColor,
                                boxShadow: const [
                                  BoxShadow(
                                    color: blackTextColor,
                                    offset: Offset(2, 3),
                                  ),
                                ],
                              ),
                              child: TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  shape:
                                      MaterialStateProperty.all<OutlinedBorder>(
                                    const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero),
                                  ),
                                ),
                                child: const Text(
                                  'Saved',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: blackTextColor,
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
