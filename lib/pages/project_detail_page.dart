import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/mock_data.dart';

class ProjectDetailPage extends StatelessWidget {
  const ProjectDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String itemId = ModalRoute.of(context)!.settings.arguments as String;
    // Fetch project details based on the itemId and display them
    Project? selectedProject;
    for (Project project in mockProjects) {
      if (project.projectId == itemId) {
        selectedProject = project;
        break;
      }
    }
    return Scaffold(
        appBar: const AuthAppBar(canBack: false),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Text.rich(
                    TextSpan(text: selectedProject!.projectDetail),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: blackTextColor,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    selectedProject.titleOfJob,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: blackTextColor,
                    ),
                  ),
                ),
                const Divider(
                  height: 1.0,
                  thickness: 2.0,
                  color: blackTextColor,
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    selectedProject.studentGain,
                    style: const TextStyle(
                      fontSize: 15,
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '\t\t\t\t\t\t-${selectedProject.projectScope}',
                      style: const TextStyle(fontSize: 15),
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '\t\t\t\t\t\t-${selectedProject.requireStudents}',
                      style: const TextStyle(fontSize: 15),
                    ),
                    dense: true,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
