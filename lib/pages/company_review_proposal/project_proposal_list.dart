import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/components/app_bar.dart';
import 'package:studenthub/components/project_proposal_item.dart';
import 'package:studenthub/components/tab_bar_item.dart';
import 'package:studenthub/data/test/data_student.dart';
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
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: MyAppBar(title: 'Project proposals')
      ),
      body: SingleChildScrollView(
        // Screen wrapper
        child: Container(
          color: const Color(0xFFF8F8F8),
          child: Column(
            children: [
              // Project name
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2)
                    )
                  ]
                ),
                padding: const EdgeInsets.only(top: 20, bottom: 12, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project Name
                    Text(
                      widget.project.name,
                      style: const TextStyle(
                        color: AppFonts.primaryColor,
                        fontSize: AppFonts.h1FontSize,
                        fontWeight: FontWeight.w600
                      )
                    ),
                    // Project post time
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: const Text(
                        'created 3 days ago',
                        style: TextStyle(
                          color: AppFonts.secondaryColor,
                          fontSize: AppFonts.h3FontSize,
                          fontWeight: FontWeight.w400
                        )
                      ),
                    ),
                    // Project proposal stats
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: const Text(
                        'Status:',
                        style: TextStyle(
                          color: AppColor.primary,
                          fontSize: AppFonts.h3FontSize,
                          fontWeight: FontWeight.w400
                        )
                      ),
                    ),
                    // Number of proposals
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 14,
                            margin: const EdgeInsets.only(right: 6),
                            child: const FaIcon(
                              FontAwesomeIcons.idCardClip,
                              size: 12
                            ),
                          ),
                          const Text(
                            'Proposals - 4',
                            style: TextStyle(
                              color: AppFonts.primaryColor,
                              fontSize: AppFonts.h3FontSize,
                              fontWeight: FontWeight.w400
                            )
                          ),
                        ]
                      ),
                    ),
                    // Number of messages
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 14,
                            margin: const EdgeInsets.only(right: 6),
                            child: const FaIcon(
                              FontAwesomeIcons.message,
                              size: 12
                            ),
                          ),
                          const Text(
                            'Messages - 8',
                            style: TextStyle(
                              color: AppFonts.primaryColor,
                              fontSize: AppFonts.h3FontSize,
                              fontWeight: FontWeight.w400
                            )
                          ),
                        ]
                      ),
                    ),
                    // Number of hired students
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 14,
                            margin: const EdgeInsets.only(right: 6),
                            child: const FaIcon(
                              FontAwesomeIcons.user,
                              size: 12
                            ),
                          ),
                          const Text(
                            'Hired - 2',
                            style: TextStyle(
                              color: AppFonts.primaryColor,
                              fontSize: AppFonts.h3FontSize,
                              fontWeight: FontWeight.w400
                            )
                          ),
                        ]
                      ),
                    ),
                  ]
                ),
              ),
              // Body
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Column(
                  children: [
                    // START: Tab Bar
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: const SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: IntrinsicWidth(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TabBarItem(isActive: true, title: 'Proposals'),
                              TabBarItem(isActive: false, title: 'Detail'),
                              TabBarItem(isActive: false, title: 'Message'),
                              TabBarItem(isActive: false, title: 'Hired'),
                            ]
                          ),
                        ),
                      )
                    ),
                    // END: Tab Bar
                    // START: Proposal List
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dataStudent.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ProjectProposalItem(
                          student: dataStudent[index]
                        );
                      }
                    ),
                  ],
                )
              )
            ]
          ),
        ),
      )
    );
  }
}