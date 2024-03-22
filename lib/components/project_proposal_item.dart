import 'package:flutter/material.dart';
import 'package:studenthub/models/student_model.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class ProjectProposalItem extends StatelessWidget {
  final StudentModel student;
  
  const ProjectProposalItem({
    super.key,
    required this.student
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2)
          )
        ]
      ),
      child: Column(
        children: [
          // Student avatar and information
          Row(
            children: [
              // Student Avatar
              Expanded(
                flex: 1,
                child: Container(
                  height: 70,
                  color: Colors.black
                )
              ),
              // Student Name + Educational level
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          color: AppFonts.primaryColor,
                          fontSize: AppFonts.h2FontSize,
                          fontWeight: FontWeight.w500
                        )
                      ),
                      Text(
                        student.educationalLevel,
                        style: const TextStyle(
                          color: AppFonts.secondaryColor,
                          fontSize: AppFonts.h3FontSize,
                          fontWeight: FontWeight.w400
                        )
                      ),
                    ]
                  ),
                )
              )
            ]
          ),
          // Student Techstack + Rating status
          Container(
            margin: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  student.techstack,
                  style: const TextStyle(
                    color: AppColor.primary,
                    fontSize: AppFonts.h3FontSize,
                    fontWeight: FontWeight.w500
                  )
                ),
                const Text(
                  'Excellent',
                  style: TextStyle(
                    color: Colors.deepOrangeAccent,
                    fontSize: AppFonts.h3FontSize,
                    fontWeight: FontWeight.w500
                  )
                ),
              ],
            ),
          ),
          // Proposal Comment
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2)
                      )
                    ]
                  ),
                  margin: const EdgeInsets.only(bottom: 10),
                  child: const Text(
                    'After reviewing your project, I\'m really impressed with its creativity and potential. I\'m confident that I\'m a great fit for the role and I\'m excited to commit to its success. Thanks for considering me—I\'m looking forward to being part of such an exciting project!',
                    style: TextStyle(
                      color: AppFonts.secondaryColor,
                      fontSize: AppFonts.h4FontSize
                    ),
                  )
                )
              )
            ]
          ),
          // Buttons
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: const Text(
                      'Message',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppFonts.h3FontSize,
                        fontWeight: FontWeight.w500
                      )
                    )
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(left: 6),
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                    decoration: BoxDecoration(
                      color: AppColor.tertiary,
                      borderRadius: BorderRadius.circular(6)
                    ),
                    child: const Text(
                      'Hire',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: AppFonts.h3FontSize,
                        fontWeight: FontWeight.w500
                      )
                    )
                  ),
                )
              ],
            ),
          )
        ],
      )
    );
  }
}