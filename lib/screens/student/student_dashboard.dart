// ignore_for_file: prefer_final_fields

import 'dart:convert';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/screens/student/student_dashboard_detail.dart';
import 'package:studenthub/utils/font.dart';
import 'package:http/http.dart' as http;
import 'package:studenthub/config/config.dart';
import 'package:studenthub/utils/timer.dart';
import '../../utils/colors.dart';
import '../../utils/statusflag_conversed.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
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
        Uri.parse('$uriBase/api/proposal/project/$_currentIdStudent?typeFlag=0'),
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        final responseDecode = jsonDecode(response.body)['result'];
        if (jsonDecode(response.body)['result'] != null) {
          for (int i = 0; i < responseDecode.length; i++) {
            if (responseDecode[i]['statusFlag'] != 0) {
              _responseActiveProposal.add(responseDecode[i]!);
            } else {
              _responseSubmitProposal.add(responseDecode[i]!);
            }
          }
        }
      } else {
        throw ('Status response of _loadActiveProposal() is ${response.statusCode}');
      }
    } catch (e) {
      print(e);
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
        if (responseDecode[i]['project']['typeFlag'] == 1 && responseDecode[i]['statusFlag'] == 3) {
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
        if (responseDecode[i]['project']['typeFlag'] == 2 && responseDecode[i]['status'] == 3) {
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
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/company/dashboard',
          (route) => route.settings.name == '/home',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(10)),
                child: TabBar(
                    indicator: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                      // border: Border.all(width: 1),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
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
                                        border:
                                            Border.all(color: Theme.of(context).colorScheme.shadow),
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
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            itemCount: _responseActiveProposal.length,
                                            // Number of items in your list
                                            itemBuilder: (BuildContext context, int index) {
                                              // itemBuilder builds each item in the list
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Card(
                                                    color: Theme.of(context).colorScheme.surface,
                                                    surfaceTintColor: Colors.transparent,
                                                    elevation: 2.0,
                                                    shadowColor:
                                                        Theme.of(context).colorScheme.shadow,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: OptionItemAllProjectScreen(
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
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
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
                                        border:
                                            Border.all(color: Theme.of(context).colorScheme.shadow),
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
                                          child: ListView.builder(
                                            itemCount: _responseSubmitProposal.length,
                                            // Number of items in your list
                                            itemBuilder: (BuildContext context, int index) {
                                              return Column(
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  Card(
                                                    color: Theme.of(context).colorScheme.surface,
                                                    surfaceTintColor: Colors.transparent,
                                                    elevation: 2.0,
                                                    shadowColor:
                                                        Theme.of(context).colorScheme.shadow,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(10.0),
                                                      child: OptionItemAllProjectScreen(
                                                          onTap: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    StudentDashboardDetail(
                                                                  detailProject:
                                                                      _responseSubmitProposal[
                                                                          index],
                                                                  nameStudent:
                                                                      _prefs.getString('username')!,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                          response: _responseSubmitProposal[index]),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
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
                              itemBuilder: (BuildContext context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Card(
                                      color: Theme.of(context).colorScheme.surface,
                                      surfaceTintColor: Colors.transparent,
                                      elevation: 2.0,
                                      shadowColor: Theme.of(context).colorScheme.shadow,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: OptionItemAllProjectScreen(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => StudentDashboardDetail(
                                                  detailProject: _responseWorkingTab[index],
                                                  nameStudent: _prefs.getString('username')!,
                                                ),
                                              ),
                                            );
                                          },
                                          response: _responseWorkingTab[index],
                                        ),
                                      ),
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
                              itemBuilder: (BuildContext context, index) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Card(
                                      color: Theme.of(context).colorScheme.surface,
                                      surfaceTintColor: Colors.transparent,
                                      elevation: 2.0,
                                      shadowColor: Theme.of(context).colorScheme.shadow,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: OptionItemAllProjectScreen(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => StudentDashboardDetail(
                                                  detailProject: _responseArchivedTab[index],
                                                  nameStudent: _prefs.getString('username')!,
                                                ),
                                              ),
                                            );
                                          },
                                          response: _responseArchivedTab[index],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    )
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.response['project']['title'],
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: AppFonts.h3FontSize,
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 7,
                  decoration: BoxDecoration(
                      color: statusFlagColors(widget.response['statusFlag']),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    statusFlagConversed(widget.response['statusFlag']),
                    style: const TextStyle(color: whiteTextColor),
                  ))),
            ],
          ),
          Text(
            'Submitted ${timeSinceCreated(widget.response['createdAt'])}',
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface, fontSize: AppFonts.h4FontSize),
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Description:',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              '${widget.response['project']['description']}',
              style: TextStyle(
                fontSize: AppFonts.h4FontSize,
                color: Theme.of(context).colorScheme.onSurface,
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
