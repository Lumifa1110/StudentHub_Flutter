// radio_list_types.dart
import 'package:flutter/material.dart';
import 'custom_radiocard.dart';

enum AccountTypes { company, student }

class RadioListTypes extends StatefulWidget {
  final AccountTypes? selectedType;
  final Function(AccountTypes) onTypeSelected;

  RadioListTypes({
    Key? key,
    required this.selectedType,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  State<RadioListTypes> createState() => _RadiolisttypesState();
}

class _RadiolisttypesState extends State<RadioListTypes> {
  AccountTypes? _selectedType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedType = widget.selectedType;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: AccountTypes.values.length,
          itemBuilder: (context, index) {
            final type = AccountTypes.values[index];
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
