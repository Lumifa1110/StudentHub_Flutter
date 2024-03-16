import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/models/project_model.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class ProjectProposalListScreen extends StatefulWidget {
  const ProjectProposalListScreen({
    super.key,
    required this.project
  });

  final ProjectModel project;

  @override
  State<ProjectProposalListScreen> createState() => _ProjectProposalListScreenState();
}

class _ProjectProposalListScreenState extends State<ProjectProposalListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Add your back button action here
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Project Proposals',
          style: TextStyle(
            color: Colors.white,
            fontSize: AppFonts.h2FontSize,
            fontWeight: FontWeight.bold
          )
        ),
        actions: const [
          FaIcon(
            FontAwesomeIcons.solidUser,
            color: Color(0xffffffff),
            size: 24
          )
        ],
        backgroundColor: mainColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen header
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: const Text(
                  'Project Proposals',
                  style: TextStyle(
                    color: AppFonts.primaryColor,
                    fontSize: AppFonts.h1FontSize,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
              // Project name
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  widget.project.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  )
                ),
              )
            ]
          )
        ),
      )
    );
  }
}