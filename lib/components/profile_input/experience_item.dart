import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studenthub/models/experience_model.dart';
import 'package:studenthub/utils/font.dart';

class ExperienceItem extends StatelessWidget {
  final Experience experience;

  const ExperienceItem({
    super.key,
    required this.experience
  });

  String formatDateTime(DateTime dateTime) {
    return DateFormat('MMMM - yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppFonts.primaryColor.withOpacity(0.1)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 1,
            spreadRadius: 1,
            offset: Offset(0,1)
          )
        ],
        borderRadius: BorderRadius.circular(6)
      ),
      child: Column(
        children: [
          // Title
          Row(
            children: [
              Expanded(
                child: Text(
                  textAlign: TextAlign.left,
                  experience.title,
                  style: const TextStyle(
                    color: AppFonts.primaryColor,
                    fontSize: AppFonts.h2FontSize,
                    fontWeight: FontWeight.w500
                  )
                )
              )
            ]
          ),
          // Time
          Row(
            children: [
              Expanded(
                child: Text(
                  textAlign: TextAlign.left,
                  '${formatDateTime(experience.startMonth)} - ${formatDateTime(experience.endMonth)}',
                  style: const TextStyle(
                    color: AppFonts.secondaryColor,
                    fontSize: AppFonts.h4FontSize,
                    fontWeight: FontWeight.w400
                  )
                )
              )
            ]
          ),
          const Divider(
            height: 14
          ),
          // Description
          Row(
            children: [
              Expanded(
                child: Text(
                  textAlign: TextAlign.left,
                  experience.description,
                  style: const TextStyle(
                    color: AppFonts.secondaryColor,
                    fontSize: AppFonts.h3FontSize,
                    fontWeight: FontWeight.w400
                  )
                )
              )
            ]
          ),
          const SizedBox(height: 14),
          // Skillset
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1)),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: experience.skillsets.isEmpty
                    ? [
                      const SizedBox(
                        height: 100,
                        child: Center(
                          child: Text(
                            'No skillsets selected',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ]
                    : experience.skillsets.map((skillset) {
                      return Container(
                        height: 36,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: Colors.blue,
                        ),
                        child: Text(
                          skillset.name,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          )
        ]
      )
    );
  }
}