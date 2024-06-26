import 'package:flutter/material.dart';
import 'package:studenthub/components/user/user_avatar.dart';
import 'package:studenthub/utils/font.dart';

class ProjectHiredStudentItem extends StatelessWidget {
  final dynamic itemsProposal;

  const ProjectHiredStudentItem({super.key, required this.itemsProposal});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Theme.of(context).colorScheme.shadow),
        ),
        child: Column(
          children: [
            // Student avatar and information
            Row(children: [
              // Student Avatar
              const Expanded(flex: 1, child: UserAvatar(icon: Icons.person)),
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
                          Text(itemsProposal['student']['user']['fullname'],
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontSize: AppFonts.h2FontSize,
                                  fontWeight: FontWeight.w500)),
                          Text('Excellent',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface,
                                  fontSize: AppFonts.h3FontSize,
                                  fontWeight: FontWeight.w400)),
                        ]),
                  ))
            ]),
            // Student Techstack + Rating status
            Container(
              margin: const EdgeInsets.only(top: 4, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(itemsProposal['student']['techStack']['name']!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: AppFonts.h3FontSize,
                          fontWeight: FontWeight.w500)),
                  const Text('Excellent',
                      style: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontSize: AppFonts.h3FontSize,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ));
  }
}
