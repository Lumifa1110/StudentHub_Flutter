import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/project_proposal/index.dart';
import 'package:studenthub/data/test/data_student.dart';
import 'package:studenthub/models/project_model.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class ProjectProposalListScreen extends StatefulWidget {
   ProjectProposalListScreen({
    super.key,
    // required this.project
  });

  final ProjectModel project = ProjectModel('API');

  @override
  State<ProjectProposalListScreen> createState() => _ProjectProposalListScreenState();
}

class _ProjectProposalListScreenState extends State<ProjectProposalListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(canBack: true),
      body: DefaultTabController(
        length: 3,
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
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: const TabBar(
                  tabs: [
                    Tab(text: 'Proposals'),
                    Tab(text: 'Detail'),
                    // Tab(text: 'Message'),
                    Tab(text: 'Hire'),
                  ]
                )
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ClipRect(
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: dataStudent.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ProjectProposalItem(
                                student: dataStudent[index]
                              );
                            }
                          ),
                        ),
                        const ProjectDetailTab(),
                        SingleChildScrollView(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: dataStudent.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ProjectHiredStudentItem(
                                student: dataStudent[index]
                              );
                            }
                          ),
                        ),
                      ]
                    ),
                  ),
                ),
              )
            ]
          )
        )
      )
    );
  }
}
