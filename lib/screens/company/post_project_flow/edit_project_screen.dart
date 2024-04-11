import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/button_simple.dart';
import 'package:studenthub/components/textfield_label_v2.dart';

class EditProjectScreen extends StatefulWidget {
  final int projectId;
  const EditProjectScreen({
    Key? key,
    required this.projectId,
  }) : super(key: key);

  @override
  _EditProjectScreenState createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  late TextEditingController _titleProject = TextEditingController();
  late TextEditingController _quantityStudent = TextEditingController();
  late TextEditingController _descriptionPrject = TextEditingController();
  int _isChecked = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthAppBar(canBack: true),
      body: SingleChildScrollView(
        child: Row(
          children: [
            TextFieldWithLabel(
              label: "",
              controller: _titleProject,
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              title: const Text('Less Than 1 Month',
                  style: TextStyle(fontSize: 14)),
              leading: Radio(
                value: 0, // Set value to 3
                groupValue: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value as int;
                  });
                },
              ),
            ),
            ListTile(
              title:
                  const Text('1 to 3 months', style: TextStyle(fontSize: 14)),
              leading: Radio(
                value: 1, // Set value to 6
                groupValue: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value as int;
                  });
                },
              ),
            ),
            ListTile(
              title:
                  const Text('3 to 6 months', style: TextStyle(fontSize: 14)),
              leading: Radio(
                value: 2, // Set value to 6
                groupValue: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value as int;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('More than 6 months',
                  style: TextStyle(fontSize: 14)),
              leading: Radio(
                value: 3, // Set value to 6
                groupValue: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value as int;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldWithLabel(
                label: "How many student do you want for this project",
                controller: _quantityStudent),
            TextField(
              maxLines: 8,
              controller: _descriptionPrject,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
              ),
            ),
            ButtonSimple(label: 'Save', onPressed: () {})
          ],
        ),
      ),
    );
  }
}
