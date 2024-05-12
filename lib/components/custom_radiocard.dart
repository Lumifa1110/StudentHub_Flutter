// custom_radiocard.dart
import 'package:flutter/material.dart';

import 'package:studenthub/enums/user_role.dart';
import 'package:studenthub/utils/colors.dart';

class CustomRadioCard extends StatelessWidget {
  final UserRole accountType;
  final UserRole? selectedType;
  final VoidCallback onTap;

  const CustomRadioCard({
    Key? key,
    required this.accountType,
    required this.selectedType,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: Theme.of(context).colorScheme.onSurface,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withOpacity(0.8),
                blurRadius: 6.0,
                offset: const Offset(0, 6),
              ),
            ],
            color: selectedType == accountType
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.contact_page,
                      size: 40,
                      color: selectedType == accountType
                          ? whiteTextColor
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Radio<UserRole>(
                    value: accountType,
                    activeColor: selectedType == accountType
                        ? whiteTextColor
                        : Theme.of(context).colorScheme.onSurface,
                    groupValue: selectedType,
                    onChanged: (UserRole? value) {
                      onTap();
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  _getTypeDisplayName(accountType),
                  style: TextStyle(
                    color: selectedType == accountType
                        ? whiteTextColor
                        : Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTypeDisplayName(UserRole type) {
    switch (type) {
      case UserRole.company:
        return 'I am a company, find engineer for project';
      case UserRole.student:
        return 'I am a student, find a project';
      default:
        return '';
    }
  }
}
