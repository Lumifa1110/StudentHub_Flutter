import 'package:flutter/material.dart';
import 'package:studenthub/enums/project_scope.dart';
import 'package:studenthub/utils/colors.dart';

class RadioListProjectLength extends StatefulWidget {
  final ProjectScopeFlag? selectedLength;
  final Function(ProjectScopeFlag?) onLengthSelected;

  const RadioListProjectLength({
    Key? key,
    required this.selectedLength,
    required this.onLengthSelected,
  }) : super(key: key);

  @override
  State<RadioListProjectLength> createState() => _RadioListProjectLengthState();
}

class _RadioListProjectLengthState extends State<RadioListProjectLength> {
  ProjectScopeFlag? _selectedLength;

  @override
  void initState() {
    super.initState();
    _selectedLength = widget.selectedLength;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildRadioItem(ProjectScopeFlag.lessThanOneMonth, 'Less than 1 month'),
        buildRadioItem(ProjectScopeFlag.oneToThreeMonth, '1 to 3 months'),
        buildRadioItem(ProjectScopeFlag.threeToSixMonth, '3 to 6 months'),
        buildRadioItem(ProjectScopeFlag.moreThanSixMOnth, 'More than 6 months'),
      ],
    );
  }

  Widget buildRadioItem(ProjectScopeFlag value, String label) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLength = value;
        });
        widget.onLengthSelected(value);
      },
      child: Row(
        children: [
          Radio<ProjectScopeFlag>(
            value: value,
            groupValue: _selectedLength,
            onChanged: (ProjectScopeFlag? newValue) {
              setState(() {
                _selectedLength = newValue;
              });
              widget.onLengthSelected(newValue);
            },
          ),
          Text(
            label,
            style: const TextStyle(color: blackTextColor, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
