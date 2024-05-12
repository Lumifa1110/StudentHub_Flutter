import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/button_simple.dart';
import 'package:studenthub/components/textfield/textfield_label_v2.dart';
import 'package:studenthub/config/config.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';
import 'package:http/http.dart' as http;

import '../company_dashboard.dart';

class EditProjectScreen extends StatefulWidget {
  final int? projectId;
  final int? currentTab;
  const EditProjectScreen({
    Key? key,
    required this.projectId,
    this.currentTab,
  }) : super(key: key);

  @override
  State<EditProjectScreen> createState() => _EditProjectScreenState();
}

class _EditProjectScreenState extends State<EditProjectScreen> {
  late bool isLoading = true;
  late SharedPreferences _prefs;
  late final _token;
  late TextEditingController _titleProject;
  late TextEditingController _quantityStudent;
  late TextEditingController _descriptionPrject;
  late int _isChecked;

  Future<void> patchProject() async {
    final Map<String, dynamic> data = {
      'projectScopeFlag': _isChecked,
      'title': _titleProject.text,
      'description': _descriptionPrject.text,
      'numberOfStudents': int.parse(_quantityStudent.text),
    };

    final response = await http.patch(
      Uri.parse('$uriBase/api/project/${widget.projectId}'),
      headers: {
        'Authorization': 'Bearer $_token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      print(widget.currentTab);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CompanyDashboardScreen(
            currentTab: widget.currentTab,
          ),
        ),
      );
    } else {
      print('erro');
    }
  }

  Future<void> _loadProject() async {
    _prefs = await SharedPreferences.getInstance();
    _token = _prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse('$uriBase/api/project/${widget.projectId}'),
        headers: {'Authorization': 'Bearer $_token'},
      );
      final responseDecode = jsonDecode(response.body)['result'];

      _isChecked = responseDecode['projectScopeFlag'];
      _titleProject = TextEditingController(text: responseDecode['title']);
      _quantityStudent = TextEditingController(text: '${responseDecode['numberOfStudents']}');
      _descriptionPrject = TextEditingController(text: responseDecode['description']);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProject();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(canBack: true),
      backgroundColor: bgColor,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldWithLabel2(
                        label: 'Title of project ${widget.projectId}', controller: _titleProject),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'How long will your project take?',
                      style: TextStyle(
                        fontSize: AppFonts.h3FontSize,
                        fontWeight: FontWeight.w500,
                        color: blackTextColor,
                      ),
                    ),
                    ListTile(
                      title: const Text('Less Than 1 Month', style: TextStyle(fontSize: 14)),
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
                      title: const Text('1 to 3 months', style: TextStyle(fontSize: 14)),
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
                      title: const Text('3 to 6 months', style: TextStyle(fontSize: 14)),
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
                      title: const Text('More than 6 months', style: TextStyle(fontSize: 14)),
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
                    TextFieldWithLabel2(
                        label: "How many student do you want for this project",
                        controller: _quantityStudent),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Describe your project',
                      style: TextStyle(
                        fontSize: AppFonts.h3FontSize,
                        fontWeight: FontWeight.w500,
                        color: blackTextColor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextField(
                      maxLines: 8,
                      controller: _descriptionPrject,
                      decoration: const InputDecoration(
                        fillColor: whiteTextColor,
                        filled: true,
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonSimple(
                            label: 'Save',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Success'),
                                  content: const Text('You have successfully saved your edit project!'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        patchProject();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            isButtonEnabled: true),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
