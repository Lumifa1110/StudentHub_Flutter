import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:studenthub/components/authappbar.dart';

import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/components/textfield/search_bar.dart';
import 'package:studenthub/screens/company/alertdialog/alertdialog.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/config/config.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';
import '../../utils/timer.dart';

class CompanyDashboardScreen extends StatefulWidget {
  final int? currentTab;
  const CompanyDashboardScreen({super.key, this.currentTab});

  @override
  State<CompanyDashboardScreen> createState() => CompanyDashboardScreenState();
}

class CompanyDashboardScreenState extends State<CompanyDashboardScreen>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final TextEditingController searchController = TextEditingController();
  late List<dynamic> _listAllProject = [];
  late List<dynamic> _listProjectWorking = [];
  late List<dynamic> _listProjectArchived = [];
  late List<dynamic> _listAllProjectFiltered = [];
  late List<dynamic> _listProjectWorkingFiltered = [];
  late List<dynamic> _listProjectArchivedFiltered = [];

  late SharedPreferences _prefs;
  bool isLoading = true;
  String errorMessage = '';
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        initialIndex: widget.currentTab != null ? widget.currentTab! : 0,
        length: 3,
        vsync: this); // '3' represents the number of tabs
    _loadScreen()
        .then((_) => _loadProject())
        .then((_) => _loadWorking())
        .then((_) => _loadArchived());
  }

  // reomove a project id
  Future<void> removeAProject(dynamic projectId, {int? currentTab}) async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    final response = await http.delete(
      Uri.parse('$uriBase/api/project/$projectId'),
      // Replace $projectId with the actual ID
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CompanyDashboardScreen(
              currentTab: currentTab ?? 0,
            ),
          ),
        );
      }
    }
  }

  // Start working project
  Future<void> workingProject(dynamic project, {int? currentTab}) async {
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
    } else {
      print(response.body);
    }
  }

  //Close a project
  Future<void> archivedProject(dynamic project, {int? currentTab}) async {
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
    } else {
      print(response.body);
    }
  }

  Future<void> _loadScreen() async {
    _prefs = await SharedPreferences.getInstance();
    final role = _prefs.getInt('current_role');
    if (role == 1) {
      final profile = _prefs.getString('company_profile');
      print('Company profile: $profile');
      if (profile == 'null') {
        if (mounted) {
          Navigator.pop(context, true);
          Navigator.of(context).pushNamed('/company');
        }
      }
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/student/dashboard',
        (route) => route.settings.name == '/home',
      );
    }
  }

  Future<void> _loadProject() async {
    if (!mounted) return; // Check if the widget is still mounted
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    final companyProfile = _prefs.getString('company_profile');
    final companyId = jsonDecode(companyProfile!)['id'];

    try {
      final responseJson = await http.get(
        Uri.parse('$uriBase/api/project/company/$companyId/'),
        headers: {'Authorization': 'Bearer $token'},
      );
      // final response = await ProjectService.getProjectByCompanyId(companyId);
      final responseDecode = jsonDecode(responseJson.body)["result"];
      print('status code: ${responseJson.statusCode}');
      if (responseDecode != null) {
        _listAllProject = responseDecode;
        _listAllProjectFiltered = responseDecode;
      }
      if (mounted) {
        // Check again if the widget is still mounted before calling setState
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        print('Error: $e');
        // Check again if the widget is still mounted before calling setState
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load projects. Please try again later.';
        });
      }
      print('Error: $e');
    }
  }

  Future<void> _loadWorking() async {
    if (!mounted) return; // Check if the widget is still mounted

    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    final companyId = jsonDecode(_prefs.getString('company_profile')!)['id'];

    try {
      final responseJson = await http.get(
        Uri.parse('$uriBase/api/project/company/$companyId/?typeFlag=1'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final responseDecode = jsonDecode(responseJson.body)["result"];
      if (responseDecode != null) {
        _listProjectWorking = responseDecode;
        _listProjectWorkingFiltered = responseDecode;
      }

      if (mounted) {
        // Check again if the widget is still mounted before calling setState
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        print('Error: $e');
        // Check again if the widget is still mounted before calling setState
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load projects. Please try again later.';
        });
      }
      print('Error: $e');
    }
  }

  Future<void> _loadArchived() async {
    if (!mounted) return; // Check if the widget is still mounted

    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    final companyId = jsonDecode(_prefs.getString('company_profile')!)['id'];

    try {
      final responseJson = await http.get(
        Uri.parse('$uriBase/api/project/company/$companyId/?typeFlag=2'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final responseDecode = jsonDecode(responseJson.body)["result"];

      if (responseDecode != null) {
        _listProjectArchived = responseDecode;
        _listProjectArchivedFiltered = responseDecode;
      }

      if (mounted) {
        // Check again if the widget is still mounted before calling setState
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        print('Error: $e');
        // Check again if the widget is still mounted before calling setState
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load projects. Please try again later.';
        });
      }
      print('Error: $e');
    }
  }

  Future<void> filterProjectList() async {
    setState(() {
      _listAllProjectFiltered = _listAllProject
          .where((project) => project['title'].toLowerCase().contains(searchController.text))
          .toList();
      _listProjectWorkingFiltered = _listProjectWorking
          .where((project) => project['title'].toLowerCase().contains(searchController.text))
          .toList();
      _listProjectArchivedFiltered = _listProjectArchived
          .where((project) => project['title'].toLowerCase().contains(searchController.text))
          .toList();
    });
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
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/company/project/step1');
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Theme.of(context).colorScheme.primary,
                              ),
                              child: const Text(
                                'Post a jobs',
                                style: TextStyle(color: whiteTextColor),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Theme.of(context).colorScheme.primaryContainer,
                          ),
                          child: TabBar(
                            controller: _tabController,
                            unselectedLabelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: AppFonts.h3FontSize,
                            ),
                            indicator: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            labelColor: whiteTextColor,
                            labelStyle: const TextStyle(
                              color: blackTextColor,
                              fontSize: AppFonts.h3FontSize,
                            ),
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
                        const SizedBox(height: 5),
                        CustomSearchBar(
                            controller: searchController,
                            placeholder: 'Search',
                            onChange: filterProjectList),
                        const SizedBox(height: 15),
                        Expanded(
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              ListView.builder(
                                itemCount: _listAllProjectFiltered.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final project = _listAllProjectFiltered[index];
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Card(
                                        color: Theme.of(context).colorScheme.surface,
                                        surfaceTintColor: Colors.transparent,
                                        elevation: 2.0,
                                        shadowColor: Theme.of(context).colorScheme.shadow,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: OptionProjectCompany(
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
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              ListView.builder(
                                itemCount: _listProjectWorkingFiltered.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final project = _listProjectWorkingFiltered[index];
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Card(
                                        color: Theme.of(context).colorScheme.surface,
                                        surfaceTintColor: Colors.transparent,
                                        elevation: 2.0,
                                        shadowColor: Theme.of(context).colorScheme.shadow,
                                        child: OptionProjectCompany(
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
                                      ),
                                    ],
                                  );
                                },
                              ),
                              ListView.builder(
                                itemCount: _listProjectArchivedFiltered.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final project = _listProjectArchivedFiltered[index];
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Card(
                                        color: Theme.of(context).colorScheme.surface,
                                        surfaceTintColor: Colors.transparent,
                                        elevation: 2.0,
                                        shadowColor: Theme.of(context).colorScheme.shadow,
                                        child: OptionProjectCompany(
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
  final Future<void> Function(dynamic idProject, {int? currentTab}) removeAProject;
  final Future<void> Function(dynamic project, {int? currentTab}) workingProject;
  final Future<void> Function(dynamic project, {int? currentTab}) archivedProject;
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

  @override
  State<OptionProjectCompany> createState() => OptionProjectCompanyState();
}

class OptionProjectCompanyState extends State<OptionProjectCompany> {
  Widget buttonShowModalBottomSheet() {
    return GestureDetector(
        onTap: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: widget.project['typeFlag'] == 0
                    ? 400
                    : widget.project['typeFlag'] == 1
                        ? 350
                        : 300,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Implement your action
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectProposalListScreen(
                                project: widget.project,
                                tabShow: 0,
                              ),
                            ),
                          );
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectProposalListScreen(
                                project: widget.project,
                                tabShow: 2,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: const Text('View hired'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Implement your action
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectProposalListScreen(
                                project: widget.project,
                                tabShow: 1,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: const Text('View job posting'),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProjectScreen(
                                projectId: widget.project['id'],
                                currentTab: widget.currentTab,
                              ),
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
                              return DialogAlert(
                                titleDialog: 'remove posting',
                                textAcceptButton: 'Yes',
                                question: 'Do you want to remove the project?',
                                project: widget.project['id'],
                                currentTab: widget.currentTab,
                                fFunction: widget.removeAProject,
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
                      widget.project['typeFlag'] == 2
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
                                widget.project['typeFlag'] == 1
                                    ? const SizedBox()
                                    : ElevatedButton(
                                        onPressed: () async {
                                          // Implement your action
                                          await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              // return an AlertDialog
                                              return DialogAlert(
                                                titleDialog: 'Start working',
                                                textAcceptButton: 'Yes',
                                                question:
                                                    'Do you want to start working the project?',
                                                currentTab: widget.currentTab,
                                                project: widget.project,
                                                fFunction: widget.workingProject,
                                              );
                                            },
                                          );
                                          Navigator.pop(context, true);
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
                                        return DialogAlert(
                                          titleDialog: 'Closed a project',
                                          textAcceptButton: 'Yes',
                                          question: 'Do you want to close the project?',
                                          currentTab: widget.currentTab,
                                          project: widget.project,
                                          fFunction: widget.archivedProject,
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
        child: Container(
          height: 23,
          decoration:
              BoxDecoration(color: AppColor.primary, borderRadius: BorderRadius.circular(12)),
          child: const Center(
            child: FaIcon(FontAwesomeIcons.ellipsis, color: Colors.white, size: 16),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 7,
                  child: Text(
                    widget.project['title'],
                    style: const TextStyle(
                        color: mainColor,
                        fontSize: AppFonts.h1FontSize,
                        fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Align(alignment: Alignment.topRight, child: buttonShowModalBottomSheet()),
                )
              ],
            ),
            Text(
              'Created ${timeSinceCreated(widget.project['createdAt'])}',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '${widget.project['description']!}',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Messages: '),
                        Text('${widget.project['countMessages']}'),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Hired: '),
                        Text('${widget.project['countHired']}'),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('Proposals: '),
                        Text(
                          '${widget.project['countProposals']}',
                        ),
                      ],
                    ),
                    Container(
                      height: 20,
                      width: 80,
                      decoration: BoxDecoration(
                          color: typeFlagColors(widget.project['typeFlag']),
                          borderRadius: BorderRadius.circular(7)),
                      child: Center(
                        child: Text(
                          widget.project['typeFlag'] == 0
                              ? 'New'
                              : widget.project['typeFlag'] == 1
                                  ? 'Working'
                                  : 'Archived',
                          style: const TextStyle(color: whiteTextColor),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
