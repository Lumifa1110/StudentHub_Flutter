import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';
import 'package:http/http.dart' as http;
import 'package:studenthub/config/config.dart';

class SubmitProposalScreen extends StatefulWidget {
  final int? idProject;

  const SubmitProposalScreen({super.key, this.idProject});

  @override
  State<SubmitProposalScreen> createState() => _SubmitProposalScreenState();
}

class _SubmitProposalScreenState extends State<SubmitProposalScreen> {
  late SharedPreferences _pref;
  late String? _token;
  late int _idStudent;
  final TextEditingController _coverLetter = TextEditingController();
  bool _erro = false;

  Future<void> _loading_pref() async {
    _pref = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    _loading_pref().then((_) => _token = _pref.getString('token')).then((_) =>
        _idStudent = jsonDecode(_pref.getString('student_profile')!)['id']);
  }

  //Post proposal
  Future<void> postProposal() async {
    Map<String, dynamic> data = {
      'projectId': widget.idProject,
      'studentId': _idStudent,
      'coverLetter': _coverLetter.text,
    };
    try {
      final response = await http.post(
        Uri.parse('$uriBase/api/proposal'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $_token'
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pushReplacementNamed(context, '/list');
      } else {
        print(response.body);
      }
    } catch (e) {
      print(e);
    }
  }

  void validateTextfield(String value) {
    setState(() {
      if (value.isEmpty) {
        _erro = true;
      } else {
        _erro = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(canBack: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Cover letter',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: AppFonts.h2FontSize),
              ),
              const SizedBox(height: 10),
              const Text(
                'Describe why do you fit to this project',
                style: TextStyle(
                    fontSize: AppFonts.h3FontSize, color: blackTextColor),
              ),
              const SizedBox(height: 10),
              TextField(
                maxLines: 10,
                onChanged: validateTextfield,
                controller: _coverLetter,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    errorText: _erro ? 'Please enter cover letter' : null),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(),
                          backgroundColor: mainColor,
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: AppFonts.h3FontSize,
                              color: whiteTextColor),
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        postProposal();
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        backgroundColor: mainColor,
                      ),
                      child: const Text(
                        "Submit proposal",
                        style: TextStyle(
                            fontSize: AppFonts.h3FontSize,
                            color: whiteTextColor),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
