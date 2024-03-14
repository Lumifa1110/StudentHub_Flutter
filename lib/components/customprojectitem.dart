import 'package:flutter/material.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/mock_data.dart';

class CustomProjectItem extends StatelessWidget {
  final Project project;
  final VoidCallback onTap;

  const CustomProjectItem({
    Key? key,
    required this.project,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: blackTextColor, // Set the color of the border
              width: 2.0, // Set the width of the border
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(project.timeCreated),
            Text(project.titleOfJob),
            Text('${project.projectScope}, ${project.requireStudents} needed'),
            Text(project.studentGain),
            Text(project.numOfProposals),
          ],
        ),
      ),
    );
  }
}
