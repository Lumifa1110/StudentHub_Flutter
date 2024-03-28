// custom_radiocard.dart
import 'package:flutter/material.dart';
import 'package:studenthub/components/radiolisttypes.dart';
import 'package:studenthub/utils/colors.dart';

class CustomRadioCard extends StatelessWidget {
  final AccountTypes accountType;
  final AccountTypes? selectedType;
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
            border: Border.all(
              color: blackTextColor,
              width: 2.0,
            ),
            color:
                selectedType == accountType ? lightestgrayColor : Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.contact_page,
                      size: 40,
                    ),
                  ),
                  Radio<AccountTypes>(
                    value: accountType,
                    activeColor: blackTextColor,
                    groupValue: selectedType,
                    onChanged: (AccountTypes? value) {
                      onTap();
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text(
                  _getTypeDisplayName(accountType),
                  style: const TextStyle(
                    color: blackTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTypeDisplayName(AccountTypes type) {
    switch (type) {
      case AccountTypes.company:
        return 'I am a company, find engineer for project';
      case AccountTypes.student:
        return 'I am a student, find a project';
    }
  }
}
