import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:studenthub/business/company_business.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/models/company_model.dart';
import 'package:studenthub/models/project_model.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/config/config.dart';

class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({Key? key}) : super(key: key);

  @override
  State<CompanyDashboardScreen> createState() => CompanyDashboardScreenState();
}

class CompanyDashboardScreenState extends State<CompanyDashboardScreen> {
  late List<Project> listProjectGet = [];
  late SharedPreferences _prefs;
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadScreen().then((_) => _loadProject());
  }

  Future<void> _loadScreen() async {
    _prefs = await SharedPreferences.getInstance();
    final profile = _prefs.getString('companyprofile');
    if (profile == null) {
      Navigator.pushReplacementNamed(context, '/company/profile');
    }
  }

  Future<void> _loadProject() async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    final companyProfile = _prefs.getString('companyprofile');
    final companyId = jsonDecode(_prefs.getString('companyprofile')?? '{}')['id'];

    try {
      final responseJson = await http.get(
        Uri.parse('${uriBase}/api/project/company/$companyId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final responseDecode = jsonDecode(responseJson.body)["result"];
      listProjectGet.clear();
      for (int i = 0; i < responseDecode.length; i++) {
        final projectScore = convertProjectScoreFlagToTime(
            responseDecode[i]['projectScopeFlag']);
        listProjectGet.add(Project(projectId: responseDecode[i]['id'], createdAt: responseDecode[i]['createdAt'], updatedAt: responseDecode[i]['updatedAt'], deletedAt: responseDecode[i]['deletedAt'], companyId: responseDecode[i]['companyId'], projectScopeFlag: responseDecode[i]['projectScopeFlag'], title: responseDecode[i]['title'], description: responseDecode[i]['description'], numberOfStudents: responseDecode[i]['numberOfStudents'], typeFlag: responseDecode[i]['typeFlag'], countProposals: responseDecode[i]['countProposals'], isFavorite: responseDecode[i]['isFavorite']));
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load projects. Please try again later.';
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(
        canBack: false,
        isFromDashBoard: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : Padding(
                  padding: const EdgeInsets.all(20),
                  child: DefaultTabController(
                    length: 2,
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
                                Navigator.pushNamed(
                                    context, '/company/project/step1');
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: const RoundedRectangleBorder()),
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
                                text: 'Archived',
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              ListView.builder(
                                itemCount: listProjectGet.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final project = listProjectGet[index];
                                  return Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      OptionProjectCompany(
                                        onTap: () {
                                          print (project.projectId);
                                        },
                                        project: project,
                                      ),
                                      if (index < listProjectGet.length - 1)
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
                              const Center(child: Text('Archived content')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
      bottomNavigationBar: const CustomBottomNavBar(
        initialIndex: 1,
      ),
    );
  }
}

class OptionProjectCompany extends StatefulWidget {
  final VoidCallback onTap;
  final Project project;

  const OptionProjectCompany(
      {Key? key, required this.onTap, required this.project})
      : super(key: key);

  int f_dayCreatedAgo(String createdAt){
    DateTime timeParse = DateTime.parse(createdAt);
    DateTime now = DateTime.now();
    Duration difference = now.difference(timeParse);

    return difference.inDays;
  }

  Future<void> deleteAProject(int projectID) async{

  }
  @override
  State<OptionProjectCompany> createState() => OptionProjectCompanyState();
}

class OptionProjectCompanyState extends State<OptionProjectCompany> {
  late SharedPreferences _prefs;

  Future<void> removeAProject(int? projectId) async{
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    final response = await http.delete(
      Uri.parse('$uriBase/api/project/$projectId'), // Replace $projectId with the actual ID
      headers: {'Authorization': 'Bearer $token'},
    );
    print(response.statusCode);
    print(projectId);

    if(response.statusCode == 200){
      print('okee');
    }
    else
      print('erro remove a project');
  }
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
                  widget.project.title,
                  style: const TextStyle(color: Colors.green),
                ),
                Text(
                  'Created ${widget.f_dayCreatedAgo(widget.project.createdAt)} days ago',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Students are looking for'),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                      '• Clear expectation about your project or deliverables'),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text('0'), Text('Proposals')],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text('0'), Text('Messages')],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text('0'), Text('Hired')],
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
                    height: 350,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              // Implement your action
                              Navigator.pop(context);
                            },
                            child: const Text('View Proposals'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Implement your action
                              Navigator.pop(context);
                            },
                            child: const Text('View messages'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Implement your action
                              Navigator.pop(context);
                            },
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
                            child: const Text('View job posting'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Implement your action
                              Navigator.pop(context);
                            },
                            child: const Text('Edit posting'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // print(widget.project.projectId.runtimeType);
                              removeAProject(widget.project.projectId);
                              // print(widget.project.projectId);
                            },
                            child: const Text('Remove posting'),
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
