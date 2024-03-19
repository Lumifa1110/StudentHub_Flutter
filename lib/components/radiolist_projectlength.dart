// radio_list_types.dart
import 'package:flutter/material.dart';
import 'package:studenthub/utils/colors.dart';

class RadioListProjectLength extends StatefulWidget {
  final String? selectedLength;
  final Function(String) onTypeSelected;

  const RadioListProjectLength({
    Key? key, // Changed super.key to Key? key
    required this.selectedLength,
    required this.onTypeSelected,
  });

  @override
  State<RadioListProjectLength> createState() => _RadioListProjectLengthState();
}

class _RadioListProjectLengthState extends State<RadioListProjectLength> {
  String? _selectedLength; // Remove initialization here

  @override
  void initState() {
    super.initState();
    _selectedLength = widget.selectedLength; // Initialize _selectedLength here
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RadioListTile(
          title: const Text(
            "Less than 1 month",
            style: TextStyle(color: blackTextColor),
          ),
          value: 'less than one',
          contentPadding: EdgeInsets.zero,
          groupValue: _selectedLength,
          onChanged: (value) {
            setState(() {
              _selectedLength = value as String?;
            });
            widget.onTypeSelected(value as String);
          },
        ),
        RadioListTile(
          title: const Text(
            '1 to 3 months',
            style: TextStyle(color: blackTextColor),
          ),
          value: 'one to three',
          contentPadding: EdgeInsets.zero,
          groupValue: _selectedLength,
          onChanged: (value) {
            setState(() {
              _selectedLength = value as String?;
            });
            widget.onTypeSelected(value as String);
          },
        ),
        RadioListTile(
          title: const Text(
            '3 to 6 months',
            style: TextStyle(color: blackTextColor),
          ),
          value: 'three to six',
          contentPadding: EdgeInsets.zero,
          groupValue: _selectedLength,
          onChanged: (value) {
            setState(() {
              _selectedLength = value as String?;
            });
            widget.onTypeSelected(value as String);
          },
        ),
        RadioListTile(
          title: const Text(
            'More than 6 months',
            style: TextStyle(color: blackTextColor),
          ),
          value: 'more than six',
          contentPadding: EdgeInsets.zero,
          groupValue: _selectedLength,
          onChanged: (value) {
            setState(() {
              _selectedLength = value as String?;
            });
            widget.onTypeSelected(value as String);
          },
        ),
      ],
    );
  }
}
