// radio_list_types.dart
import 'package:flutter/material.dart';
import 'package:studenthub/enums/user_role.dart';
import 'custom_radiocard.dart';

class RadioListTypes extends StatefulWidget {
  final UserRole? selectedType;
  final Function(UserRole) onTypeSelected;

  RadioListTypes({
    Key? key,
    required this.selectedType,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  State<RadioListTypes> createState() => _RadiolisttypesState();
}

class _RadiolisttypesState extends State<RadioListTypes> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: UserRole.values.length,
          itemBuilder: (context, index) {
            final type = UserRole.values[index];
            return CustomRadioCard(
              accountType: type,
              selectedType: widget.selectedType,
              onTap: () {
                widget.onTypeSelected(type);
              },
            );
          },
        ),
      ],
    );
  }
}
