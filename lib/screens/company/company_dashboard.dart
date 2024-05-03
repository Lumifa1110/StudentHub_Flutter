import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:studenthub/business/company_business.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/models/company_model.dart';
import 'package:studenthub/screens/company/alertdialog/alertdialog.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/config/config.dart';
import 'package:studenthub/services/project_service.dart';

class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState() => CompanyDashboardScreenState();
}

class CompanyDashboardScreenState extends State<CompanyDashboardScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late List<dynamic> _listAllProject = [];
  late List<dynamic> _listProjectWorking = [];
  late List<dynamic> _listProjectArchived = [];

  late SharedPreferences _prefs;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadScreen()
        .then((_) => _loadProject())
        .then((_) => _loadWorking())
        .then((_) => _loadArchived());
  }

  // reomove a project id
  Future<void> removeAProject(dynamic projectId) async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    final response = await http.delete(
      Uri.parse('$uriBase/api/project/$projectId'),
      // Replace $projectId with the actual ID
      headers: {'Authorization': 'Bearer $token'},
    );
    setState(() {
      isLoading = true;
      _loadScreen()
          .then((_) => _loadProject())
          .then((_) => _loadWorking())
          .then((_) => _loadArchived());
    });
  }

  // Start working project
  Future<void> workingProject(dynamic project) async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    final Map<String, dynamic> data = {
      'numberOfStudents': project['numberOfStudents'],
      'typeFlag': 1,
    };
    final response = await http.patch(
      Uri.parse('$uriBase/api/project/${project['id']}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    if (response.statusCode >= 200 || response.statusCode < 300) {
      setState(() {
        isLoading = true;
        _loadScreen()
            .then((_) => _loadProject())
            .then((_) => _loadWorking())
            .then((_) => _loadArchived());
      });
    } else
      print(response.body);
  }

  //Close a project
  Future<void> archivedProject(dynamic project) async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    final Map<String, dynamic> data = {
      'description': project['description'],
      'numberOfStudents': project['numberOfStudents'],
      'typeFlag': 2,
    };
    final response = await http.patch(
      Uri.parse('$uriBase/api/project/${project['id']}'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        isLoading = true;
        _loadScreen()
            .then((_) => _loadProject())
            .then((_) => _loadWorking())
            .then((_) => _loadArchived());
      });
    } else
      print(response.body);
  }

  Future<void> _loadScreen() async {
    _prefs = await SharedPreferences.getInstance();
    final role = _prefs.getInt('current_role');
    if (role == 1) {
      final profile = _prefs.getString('company_profile');
      print('Company profile: $profile');
      if (profile == 'null') {
        Navigator.pushReplacementNamed(context, '/company');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/student/dashboard');
    }
  }

  Future<void> _loadProject() async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    final companyProfile = _prefs.getString('company_profile');
    final companyId = jsonDecode(companyProfile!)['id'];

    try {
      final responseJson = await http.get(
        Uri.parse('$uriBase/api/project/company/$companyId/?typeFlag=0'),
        headers: {'Authorization': 'Bearer $token'},
      );
      // final response = await ProjectService.getProjectByCompanyId(companyId);
      final responseDecode = jsonDecode(responseJson.body)["result"];
      print('status code: ${responseJson.statusCode}');
      if (responseDecode != null) {
        _listAllProject = responseDecode;
      }
      if (mounted) {
        // Check again if the widget is still mounted before calling setState
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        print(e);
        // Check again if the widget is still mounted before calling setState
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load projects. Please try again later.';
        });
      }
      print(e);
    }
  }

  Future<void> _loadWorking() async {
    if (!mounted) return; // Check if the widget is still mounted

    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    final companyId = jsonDecode(_prefs.getString('company_profile')!)['id'];

    try {
      final responseJson = await http.get(
        Uri.parse('${uriBase}/api/project/company/$companyId/?typeFlag=1'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final responseDecode = jsonDecode(responseJson.body)["result"];
      if (responseDecode != null) {
        _listProjectWorking = responseDecode;
      }

      if (mounted) {
        // Check again if the widget is still mounted before calling setState
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        print(e);
        // Check again if the widget is still mounted before calling setState
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load projects. Please try again later.';
        });
      }
      print(e);
    }
  }

  Future<void> _loadArchived() async {
    if (!mounted) return; // Check if the widget is still mounted

    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    final companyId = jsonDecode(_prefs.getString('company_profile')!)['id'];

    try {
      final responseJson = await http.get(
        Uri.parse('${uriBase}/api/project/company/$companyId/?typeFlag=2'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final responseDecode = jsonDecode(responseJson.body)["result"];

      if (responseDecode != null) {
        _listProjectArchived = responseDecode;
      }

      if (mounted) {
        // Check again if the widget is still mounted before calling setState
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        print(e);
        // Check again if the widget is still mounted before calling setState
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load projects. Please try again later.';
        });
      }
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AuthAppBar(
        canBack: false,
        onRoleChanged: (result) {
          _loadScreen();
        },
        title: 'Dashboard',
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: DefaultTabController(
                    length: 3,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Your projects',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/company/project/step1');
                              },
                              style:
                                  ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()),
                              child: const Text('Post a jobs'),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TabBar(
                            indicator: BoxDecoration(
                              color: Colors.greenAccent,
                              borderRadius: BorderRadius.circular(11),
                              border: Border.all(width: 1),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            tabs: const [
                              Tab(
                                text: 'All project',
                              ),
                              Tab(
                                text: 'Working',
                              ),
                              Tab(
                                text: 'Archived',
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              ListView.builder(
                                itemCount: _listAllProject.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final project = _listAllProject[index];
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      OptionProjectCompany(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ProjectProposalListScreen(
                                                project: project,
                                              ),
                                            ),
                                          );
                                        },
                                        project: project,
                                        removeAProject: removeAProject,
                                        workingProject: workingProject,
                                        archivedProject: archivedProject,
                                        currentTab: 0,
                                      ),
                                      if (index < _listAllProject.length - 1)
                                        const Divider(
                                          thickness: 2,
                                          indent: 10,
                                          endIndent: 10,
                                          color: Colors.black,
                                        ),
                                    ],
                                  );
                                },
                              ),
                              ListView.builder(
                                itemCount: _listProjectWorking.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final project = _listProjectWorking[index];
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      OptionProjectCompany(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ProjectProposalListScreen(
                                                project: project,
                                              ),
                                            ),
                                          );
                                        },
                                        project: project,
                                        removeAProject: removeAProject,
                                        workingProject: workingProject,
                                        archivedProject: archivedProject,
                                        currentTab: 1,
                                      ),
                                      if (index < _listProjectWorking.length - 1)
                                        const Divider(
                                          thickness: 2,
                                          indent: 10,
                                          endIndent: 10,
                                          color: Colors.black,
                                        ),
                                    ],
                                  );
                                },
                              ),
                              ListView.builder(
                                itemCount: _listProjectArchived.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final project = _listProjectArchived[index];
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      OptionProjectCompany(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ProjectProposalListScreen(
                                                project: project,
                                              ),
                                            ),
                                          );
                                        },
                                        project: project,
                                        removeAProject: removeAProject,
                                        workingProject: workingProject,
                                        archivedProject: archivedProject,
                                        currentTab: 2,
                                      ),
                                      if (index < _listProjectArchived.length - 1)
                                        const Divider(
                                          thickness: 2,
                                          indent: 10,
                                          endIndent: 10,
                                          color: Colors.black,
                                        ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: const CustomBottomNavBar(initialIndex: 1),
    );
  }
}

class OptionProjectCompany extends StatefulWidget {
  final VoidCallback onTap;
  final dynamic project;
  final Future<void> Function(dynamic idProject) removeAProject;
  final Future<void> Function(dynamic project) workingProject;
  final Future<void> Function(dynamic project) archivedProject;
  final int currentTab;

  const OptionProjectCompany({
    super.key,
    required this.onTap,
    required this.project,
    required this.removeAProject,
    required this.workingProject,
    required this.archivedProject,
    required this.currentTab,
  });

  int f_dayCreatedAgo(String createdAt) {
    DateTime timeParse = DateTime.parse(createdAt);
    DateTime now = DateTime.now();
    Duration difference = now.difference(timeParse);

    return difference.inDays;
  }

  @override
  State<OptionProjectCompany> createState() => OptionProjectCompanyState();
}

class OptionProjectCompanyState extends State<OptionProjectCompany> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 15,
                ),
                Text(
                  widget.project['title'],
                  style: const TextStyle(color: Colors.green),
                ),
                Text(
                  'Created ${widget.f_dayCreatedAgo(widget.project['createdAt'])} days ago',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text('${widget.project['description']}'),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text('${widget.project['countProposals']}'), Text('Proposals')],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text('${widget.project['countMessages']}'), Text('Messages')],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text('${widget.project['countHired']}'), Text('Hired')],
                    ),
                  ],
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: widget.currentTab == 0
                        ? 450
                        : widget.currentTab == 1
                            ? 400
                            : 350,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Implement your action
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            child: const Text('View Proposals'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Implement your action
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            child: const Text('View messages'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Implement your action
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            child: const Text('View hired'),
                          ),
                          const Divider(
                            thickness: 2,
                            indent: 10,
                            endIndent: 10,
                            color: Colors.black,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Implement your action
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            child: const Text('View job posting'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Implement your action
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EditProjectScreen(projectId: widget.project['id']),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            child: const Text('Edit posting'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // Show the AlertDialog
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // return an AlertDialog
                                  return Dialog_(
                                    titleAcceptButton: 'Yes',
                                    question: 'Do you want to remove the project?',
                                    project: widget.project['id'],
                                    f_function: widget.removeAProject,
                                  );
                                },
                              );

                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0),
                              ),
                            ),
                            child: const Text('Remove posting'),
                          ),
                          widget.currentTab == 2
                              ? const SizedBox()
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const Divider(
                                      thickness: 2,
                                      indent: 10,
                                      endIndent: 10,
                                      color: Colors.black,
                                    ),
                                    widget.currentTab == 1
                                        ? const SizedBox()
                                        : ElevatedButton(
                                            onPressed: () async {
                                              // Implement your action
                                              await showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  // return an AlertDialog
                                                  return Dialog_(
                                                    titleAcceptButton: 'Yes',
                                                    question:
                                                        'Do you want to start working the project?',
                                                    project: widget.project,
                                                    f_function: widget.workingProject,
                                                  );
                                                },
                                              );
                                              Navigator.pop(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(0),
                                              ),
                                            ),
                                            child: const Text('Start working this project'),
                                          ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        // Implement your action
                                        await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            // return an AlertDialog
                                            return Dialog_(
                                              titleAcceptButton: 'Yes',
                                              question: 'Do you want to close the project?',
                                              project: widget.project,
                                              f_function: widget.archivedProject,
                                            );
                                          },
                                        );
                                        Navigator.pop(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(0),
                                        ),
                                      ),
                                      child: const Text('Closed a project'),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(shape: const CircleBorder()),
            child: const Text('...'),
          ),
        ],
      ),
    );
  }
}
