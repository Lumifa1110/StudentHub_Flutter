import 'package:flutter/material.dart';
import 'package:studenthub/components/project_proposal/dialog_send_hire.dart';
import 'package:studenthub/components/user/user_avatar.dart';
import 'package:studenthub/models/student_model.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class ProjectProposalItem extends StatefulWidget {
  final StudentModel student;
  
  const ProjectProposalItem({
    super.key,
    required this.student
  });

  @override
  State<ProjectProposalItem> createState() => _ProjectProposalItemState();
}

class _ProjectProposalItemState extends State<ProjectProposalItem> {
  late bool sentHireOffer;

  @override
  void initState() {
    super.initState();
    sentHireOffer = false;
  }

  void sendHireOffer() {
    setState(() {
      sentHireOffer = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          // Student avatar and information
          Row(
            children: [
              // Student Avatar
              const Expanded(
                flex: 1,
                child: UserAvatar(icon: Icons.person)
              ),
              // Student Name + Educational level
              Expanded(
                flex: 8,
                child: Container(
                  padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                  height: 70,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.student.name,
                        style: const TextStyle(
                          color: AppFonts.primaryColor,
                          fontSize: AppFonts.h2FontSize,
                          fontWeight: FontWeight.w500
                        )
                      ),
                      Text(
                        widget.student.educationalLevel,
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
            margin: const EdgeInsets.only(top: 4, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.student.techstack,
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
                    border: Border.all(color: Colors.black12)
                  ),
                  margin: const EdgeInsets.only(bottom: 6),
                  child: const Text(
                    'I have gone through your project and it seem like a good project. I will commit for your project.',
                    style: TextStyle(
                      color: AppFonts.secondaryColor,
                      fontSize: AppFonts.h3FontSize
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
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
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
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogSendHire(sendHireOffer: sendHireOffer);
                        },
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.only(left: 12),
                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                      decoration: BoxDecoration(
                        color: AppColor.tertiary,
                        borderRadius: BorderRadius.circular(6)
                      ),
                      child: Text(
                        sentHireOffer ? 'Sent hired offer' : 'Hire',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: AppFonts.h3FontSize,
                          fontWeight: FontWeight.w500
                        )
                      )
                    ),
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
