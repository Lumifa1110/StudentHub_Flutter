import 'package:flutter/material.dart';
import 'package:studenthub/utils/colors.dart';

class RadioListProjectLength extends StatefulWidget {
  final String? selectedLength;
  final Function(String) onLengthSelected;

  const RadioListProjectLength({
    Key? key,
    required this.selectedLength,
    required this.onLengthSelected,
  }) : super(key: key);

  @override
  State<RadioListProjectLength> createState() => _RadioListProjectLengthState();
}

class _RadioListProjectLengthState extends State<RadioListProjectLength> {
  String? _selectedLength;

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
        buildRadioItem('less than one', 'Less than 1 month'),
        buildRadioItem('one to three', '1 to 3 months'),
        buildRadioItem('three to six', '3 to 6 months'),
        buildRadioItem('more than six', 'More than 6 months'),
      ],
    );
  }

  Widget buildRadioItem(String value, String label) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedLength = value;
        });
        widget.onLengthSelected(value);
      },
      child: Row(
        children: [
          Radio(
            value: value,
            groupValue: _selectedLength,
            onChanged: (newValue) {
              setState(() {
                _selectedLength = newValue as String?;
              });
              widget.onLengthSelected(newValue as String);
            },
          ),
          Text(
            label,
            style: TextStyle(color: blackTextColor, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
