import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studenthub/models/education_model.dart';
import 'package:studenthub/utils/font.dart';

class EducationItem extends StatelessWidget {
  final Education education;
  final VoidCallback handleDelete;

  const EducationItem({
    super.key,
    required this.education,
    required this.handleDelete
  });

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  textAlign: TextAlign.left,
                  education.schoolName,
                  style: const TextStyle(
                    color: AppFonts.primaryColor,
                    fontSize: AppFonts.h3FontSize,
                    fontWeight: FontWeight.w500
                  )
                ),
                const SizedBox(height: 6),
                Text(
                  textAlign: TextAlign.left,
                  education.endYear != null
                    ? '${formatDateTime(education.startYear)} - ${formatDateTime(education.endYear!)}'
                    : formatDateTime(education.endYear!),
                  style: const TextStyle(
                    color: AppFonts.secondaryColor,
                    fontSize: AppFonts.h4FontSize,
                    fontWeight: FontWeight.w500
                  )
                ),
              ]
            )
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                handleDelete();
              },
              child: Container(
                alignment: Alignment.centerRight,
                child: const Icon(
                  Icons.clear,
                  size: AppFonts.h2FontSize
                ),
              ),
            )
          ),
        ]
      )
    );
  }
}