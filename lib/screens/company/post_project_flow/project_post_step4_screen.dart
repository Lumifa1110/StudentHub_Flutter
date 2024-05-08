import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/utils/font.dart';
import 'package:studenthub/models/company_model.dart';
import 'package:http/http.dart' as http;
import 'package:studenthub/business/company_business.dart';
import 'package:studenthub/config/config.dart';

class ProjectPostStep4Page extends StatefulWidget {
  final Map<String, dynamic> box;
  const ProjectPostStep4Page({super.key, required this.box});

  @override
  State<ProjectPostStep4Page> createState() => _ProjectPostStep4PageState();
}

class _ProjectPostStep4PageState extends State<ProjectPostStep4Page> {
  late SharedPreferences _prefs;

  Future<void> postProject(BuildContext context) async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    final idCompany = jsonDecode(_prefs.getString('company_profile')!)['id'];
    ProjectPost modelDataProject = ProjectPost('$idCompany', widget.box['projectScore'],
        widget.box['title'], widget.box['quantityStudent'], widget.box['description']);
    final modelDataProjectJson = modelDataProject.toJson();
    try {
      final response = await http.post(
        Uri.parse('$uriBase/api/project'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(modelDataProjectJson),
      );
      if (response.statusCode == 201) {
        Navigator.pushReplacementNamed(context, '/company/dashboard');
      } else
        print(response.body);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(canBack: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '4/4 \t \t Project details',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppFonts.h2FontSize),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '${widget.box['title']}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: AppFonts.h1FontSize,
                        overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    thickness: 2,
                    indent: 10,
                    endIndent: 10,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Describe your project:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      widget.box['description'],
                      overflow: TextOverflow.ellipsis,
                      maxLines: 10,
                      softWrap: true,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    thickness: 2,
                    indent: 10,
                    endIndent: 10,
                    color: Colors.black,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.clock,
                        size: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Project scope',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text(
                                  '• ${convertProjectScoreFlagToTime(widget.box['projectScore'])} months'),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.person_2,
                        size: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Student required',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 15.0),
                              child: Text('• ${widget.box['quantityStudent']} students'),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () async {
                    postProject(context);
                  },
                  style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()),
                  child: const Text('Post job'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
