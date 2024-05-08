import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/screens/student/student_dashboard_detail.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';
import 'package:http/http.dart' as http;
import 'package:studenthub/config/config.dart';
import 'package:studenthub/utils/timer.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  late SharedPreferences _prefs;
  late String? _token;
  late int _currentIdStudent;
  bool isLoading = true;
  late List<dynamic> _responseSubmitProposal = [];
  late List<dynamic> _responseActiveProposal = [];
  late List<dynamic> _responseWorkingTab = [];
  late List<dynamic> _responseArchivedTab = [];
  final http.Client _client = http.Client();

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadScreen();
  }

  //Loading data of All Project Tab.
  Future<void> _loadTabAllProject() async {
    //Loading Active proposal
    try {
      final response = await _client.get(
        Uri.parse('$uriBase/api/proposal/project/$_currentIdStudent?statusFlag=1&typeFlag=0'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        if (jsonDecode(response.body)['result'] != null) {
          _responseActiveProposal = jsonDecode(response.body)['result'];
        }
      } else {
        throw ('Status response of _loadActiveProposal() is ${response.statusCode}');
      }
    } catch (e) {
      print(e);
    }

    //Loading submitted proposal
    try {
      final response = await _client.get(
        Uri.parse('$uriBase/api/proposal/project/$_currentIdStudent?statusFlag=0&typeFlag=0'),
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonDecode(response.body)['result'] != null) {
          _responseSubmitProposal = jsonDecode(response.body)['result'];
        }
      } else {
        throw ('Status response of _loadSubmitProposal() is ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  //Loading data of working Tab
  Future<void> _loadWorkingTab() async {
    try {
      final response = await _client.get(
        Uri.parse('$uriBase/api/proposal/project/$_currentIdStudent'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      final List<dynamic> responseDecode = jsonDecode(response.body)['result'];

      for (int i = 0; i < responseDecode.length; i++) {
        if (responseDecode[i]['project']['typeFlag'] == 1) {
          _responseWorkingTab.add(responseDecode[i]);
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  //Loading data of archived Tab
  Future<void> _loadArchivedTab() async {
    try {
      final response = await _client.get(
        Uri.parse('$uriBase/api/proposal/project/$_currentIdStudent?statusFlag=3&typeFlag=2'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      final List<dynamic> responseDecode = jsonDecode(response.body)['result'];

      for (int i = 0; i < responseDecode.length; i++) {
        if (responseDecode[i]['project']['typeFlag'] == 2) {
          _responseArchivedTab.add(responseDecode[i]);
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _loadScreen() async {
    print('student dashboard');
    _prefs = await SharedPreferences.getInstance();
    // _token = _prefs.getString('token');
    final role = _prefs.getInt('current_role');
    print('Role: $role');

    if (role == 0) {
      final profile = _prefs.getString('student_profile');
      if (profile == 'null') {
        if (mounted) {
          Navigator.pop(context, true);
          Navigator.of(context).pushNamed('/student');
        }
      } else {
        _token = _prefs.getString('token');
        _currentIdStudent = jsonDecode(_prefs.getString('student_profile')!)['id'];
        _loadTabAllProject().then((_) => _loadWorkingTab()).then((_) => _loadArchivedTab()).then(
          (_) {
            if (mounted) {
              setState(
                () {
                  isLoading = false;
                },
              );
            }
          },
        );
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/company/dashboard',
        (route) => route.settings.name == '/home',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthAppBar(
        canBack: false,
        onRoleChanged: (result) {
          _loadScreen();
        },
        title: 'Dashboard',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: DefaultTabController(
          length: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your projects',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppFonts.h3FontSize),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: blackTextColor),
                    borderRadius: BorderRadius.circular(10)),
                child: TabBar(
                    indicator: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: whiteTextColor,
                    tabs: const <Widget>[
                      Tab(
                        text: 'All project',
                      ),
                      Tab(
                        text: 'Working',
                      ),
                      Tab(
                        text: 'Archived',
                      )
                    ]),
              ),
              Expanded(
                child: TabBarView(children: [
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : Center(
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                  flex: _responseActiveProposal.isEmpty ? 1 : 6,
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: blackTextColor),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Active proposal (${_responseActiveProposal.length})',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: AppFonts.h3FontSize),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: ListView.builder(
                                              itemCount: _responseActiveProposal.length,
                                              // Number of items in your list
                                              itemBuilder: (BuildContext context, int index) {
                                                // itemBuilder builds each item in the list
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    OptionItemAllProjectScreen(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                StudentDashboardDetail(
                                                              detailProject:
                                                                  _responseActiveProposal[index],
                                                              nameStudent:
                                                                  _prefs.getString('username')!,
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      response: _responseActiveProposal[index],
                                                    ),
                                                    if (index != _responseActiveProposal.length - 1)
                                                      const Divider(
                                                        height: 60,
                                                        endIndent: 10,
                                                        thickness: 2,
                                                      )
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                              Expanded(
                                  flex: 6,
                                  child: Container(
                                    padding: const EdgeInsets.all(10.0),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: blackTextColor),
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Submitted proposal (${_responseSubmitProposal.length})',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: AppFonts.h3FontSize),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: ListView.builder(
                                              itemCount: _responseSubmitProposal.length,
                                              // Number of items in your list
                                              itemBuilder: (BuildContext context, int index) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  children: [
                                                    OptionItemAllProjectScreen(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  StudentDashboardDetail(
                                                                detailProject:
                                                                    _responseSubmitProposal[index],
                                                                nameStudent:
                                                                    _prefs.getString('username')!,
                                                              ),
                                                            ),
                                                          );
                                                        },
                                                        response: _responseSubmitProposal[index]),
                                                    index == _responseSubmitProposal.length - 1
                                                        ? const SizedBox()
                                                        : const Divider(
                                                            height: 60,
                                                            endIndent: 10,
                                                            thickness: 2,
                                                          ),
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              const SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: _responseWorkingTab.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    OptionItemWorkingAndArchiedScreen(
                                      onTap: () {},
                                      response: _responseWorkingTab[index],
                                    ),
                                    index == _responseWorkingTab.length - 1
                                        ? const SizedBox()
                                        : const Divider(
                                            height: 60,
                                            endIndent: 10,
                                            thickness: 2,
                                          ),
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: ListView.builder(
                              itemCount: _responseArchivedTab.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    OptionItemWorkingAndArchiedScreen(
                                      onTap: () {},
                                      response: _responseArchivedTab[index],
                                    ),
                                    index == _responseArchivedTab.length - 1
                                        ? const SizedBox()
                                        : const Divider(
                                            height: 60,
                                            endIndent: 10,
                                            thickness: 2,
                                          ),
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(initialIndex: 1),
    );
  }
}

class OptionItemAllProjectScreen extends StatefulWidget {
  final VoidCallback onTap;
  final dynamic response;

  const OptionItemAllProjectScreen({super.key, required this.onTap, this.response});

  @override
  State<OptionItemAllProjectScreen> createState() => _OptionItemAllProjectScreenState();
}

class _OptionItemAllProjectScreenState extends State<OptionItemAllProjectScreen> {
  @override
  Widget build(BuildContext context) {
    if (!mounted) return const SizedBox();
    return InkWell(
      onTap: widget.onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.response['project']['title'],
            style: const TextStyle(color: AppColor.tertiary, fontSize: AppFonts.h3FontSize),
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'Submitted ${timeSinceCreated(widget.response['createdAt'])}',
            style: const TextStyle(color: lightergrayColor, fontSize: AppFonts.h4FontSize),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              '${widget.response['project']['description']}',
              style: const TextStyle(
                fontSize: AppFonts.h4FontSize,
                color: blackTextColor,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class OptionItemWorkingAndArchiedScreen extends StatefulWidget {
  final VoidCallback onTap;
  final dynamic response;

  const OptionItemWorkingAndArchiedScreen({super.key, required this.onTap, this.response});

  @override
  State<OptionItemWorkingAndArchiedScreen> createState() => _OptionItemWorkingScreenState();
}

class _OptionItemWorkingScreenState extends State<OptionItemWorkingAndArchiedScreen> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.response['project']['title'],
              style: const TextStyle(color: Colors.green),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Time ${convertProjectScoreFlagToTime(widget.response['project']['projectScopeFlag'])}, ${widget.response['project']['numberOfStudents']} students',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('Students are looking for'),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('${widget.response['project']['description']}'),
            ),
          ],
        ),
      ),
    );
  }
}
