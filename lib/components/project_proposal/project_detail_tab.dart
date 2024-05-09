import 'package:flutter/material.dart';

import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';
import 'package:studenthub/business/company_business.dart';

class ProjectDetailTab extends StatelessWidget {
  final dynamic project;

  const ProjectDetailTab({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          decoration:
              BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6), boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 2))
          ]),
          child: Column(
            children: [
              // Scopes
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.access_time,
                        size: 30,
                        color: AppColor.primary,
                      )),
                  Expanded(
                      flex: 12,
                      child: Container(
                        padding: const EdgeInsets.only(left: 20),
                        height: 40,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                child: Text('Project scope',
                                    style: TextStyle(
                                        color: AppColor.primary,
                                        fontSize: AppFonts.h3FontSize,
                                        fontWeight: FontWeight.w500)),
                              ),
                              Expanded(
                                child: Text(
                                    convertProjectScoreFlagToTime(project['projectScopeFlag']!),
                                    style: const TextStyle(
                                        color: AppFonts.primaryColor,
                                        fontSize: AppFonts.h3FontSize,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ]),
                      ))
                ]),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black12),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  const Expanded(
                      flex: 1,
                      child: Icon(
                        Icons.group,
                        size: 30,
                        color: AppColor.primary,
                      )),
                  Expanded(
                      flex: 12,
                      child: Container(
                        padding: const EdgeInsets.only(left: 20),
                        height: 40,
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                child: Text('Student required:',
                                    style: TextStyle(
                                        color: AppColor.primary,
                                        fontSize: AppFonts.h3FontSize,
                                        fontWeight: FontWeight.w500)),
                              ),
                              Expanded(
                                child: Text('${project['numberOfStudents']} students',
                                    style: const TextStyle(
                                        color: AppFonts.primaryColor,
                                        fontSize: AppFonts.h3FontSize,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ]),
                      ))
                ]),
              ),
              const SizedBox(height: 12),
              // Proposal Comment
              Row(children: [
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black12)),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                                children: [
                            const Expanded(
                                flex: 1,
                                child: Icon(
                                  Icons.description,
                                  size: 30,
                                  color: AppColor.primary,
                                )),
                            Expanded(
                                flex: 12,
                                child: Container(
                                  padding: const EdgeInsets.only(left: 20),
                                  // height: 40,
                                  child:const Text('Description',
                                      style: TextStyle(
                                          color: AppColor.primary,
                                          fontSize: AppFonts.h3FontSize,
                                          fontWeight: FontWeight.w500)),
                                ))
                          ]),
                            const SizedBox(height: 12),
                            Text('     ${project['description']!}',
                              style: const TextStyle(
                                  color: AppFonts.secondaryColor, fontSize: AppFonts.h3FontSize),
                            ),
                          ],
                        )))
              ]),
            ],
          )),
    );
  }
}
