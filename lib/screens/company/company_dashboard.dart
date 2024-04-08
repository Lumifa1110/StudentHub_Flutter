import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/models/project_model.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/utils/apiBase.dart';
import '../../components/appbar_ps1.dart';
import 'package:studenthub/models/company_model.dart';
import 'package:studenthub/data/test/data_project.dart';
import 'package:http/http.dart' as http;

class CompanyDashboardScreen extends StatefulWidget {
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState() => CompanyDashboardScreenState();
}

class CompanyDashboardScreenState extends State<CompanyDashboardScreen> {
  late List<Project> listProjectGet = [];

  Future<void> fechProjectData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      final response = await http.get(
        Uri.parse('${BASE_URL}api/project'),
        headers: {'Authorization': 'Bearer ${token}'},
      );
      // print('${jsonDecode(response.body)["result"]}');
      final listProjectEncode = jsonDecode(response.body)["result"];
      for (int i = 0; i < listProjectEncode.length; i++) {
        listProjectGet.add(Project(
            title: listProjectEncode[i]['title'],
            implementationTime: "Null",
            qualityStudent: 0,
            describe: listProjectEncode[i]['description'],
            createdAt: listProjectEncode[i]['createdAt']));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _loadProject() async {
    fechProjectData();
  }

  @override
  void initState() {
    super.initState();
    _loadProject();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(canBack: false, title: 'Dashboard'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    'Your projects',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProjectPostStep1Screen()));
                      },
                      style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder()),
                      child: const Text('Post a jobs'))
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 2),
                    borderRadius: BorderRadius.circular(12)),
                child: TabBar(
                    indicator: BoxDecoration(
                      color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(width: 1),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const <Widget>[
                      Tab(
                        text: 'All project',
                      ),
                      Tab(
                        text: 'Archieved',
                      )
                    ]),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Center(
                      child: Column(children: [
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProjectProposalListScreen(
                                            project: ProjectModel(
                                                'Senior Front-end Developer'))));
                          },
                          child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          'Senior frontend developer (Fintech)',
                                          style: TextStyle(color: Colors.green),
                                        ),
                                        Text(
                                          'Created 3 days ago',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text('Students are looking for'),
                                        Padding(
                                          padding: EdgeInsets.only(left: 20),
                                          child: Text(
                                              '• Clear expectation about your project or deliverables'),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('0'),
                                                Text('Proposals')
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('8'),
                                                Text('Messages')
                                              ],
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('2'),
                                                Text('Hired')
                                              ],
                                            ),
                                          ],
                                        ),
                                      ]),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 350,
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              // mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  style: ElevatedButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      minimumSize: const Size(
                                                          double.infinity, 0),
                                                      shape:
                                                          const RoundedRectangleBorder()),
                                                  child: const Text(
                                                      'View Proposals'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  style: ElevatedButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      minimumSize: const Size(
                                                          double.infinity, 0),
                                                      shape:
                                                          const RoundedRectangleBorder()),
                                                  child: const Text(
                                                      'View messages'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  style: ElevatedButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      minimumSize: const Size(
                                                          double.infinity, 0),
                                                      shape:
                                                          const RoundedRectangleBorder()),
                                                  child:
                                                      const Text('View hired'),
                                                ),
                                                const Divider(
                                                  thickness: 2,
                                                  indent: 10,
                                                  endIndent: 10,
                                                  color: Colors.black,
                                                ),
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  style: ElevatedButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      minimumSize: const Size(
                                                          double.infinity, 0),
                                                      shape:
                                                          const RoundedRectangleBorder()),
                                                  child: const Text(
                                                      'View job posting'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  style: ElevatedButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      minimumSize: const Size(
                                                          double.infinity, 0),
                                                      shape:
                                                          const RoundedRectangleBorder()),
                                                  child: const Text(
                                                      'Edit posting'),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  style: ElevatedButton.styleFrom(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              16.0),
                                                      minimumSize: const Size(
                                                          double.infinity, 0),
                                                      shape:
                                                          const RoundedRectangleBorder()),
                                                  child: const Text(
                                                      'Remove posting'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shape: const CircleBorder()),
                                  child: const Text('...'),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Divider(
                          thickness: 2,
                          endIndent: 10,
                          color: Colors.black,
                        ),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Senior frontend developer (Fintech)',
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      Text('Created 5 days ago',
                                          style: TextStyle(color: Colors.grey)),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text('Students are looking for'),
                                      Padding(
                                        padding: EdgeInsets.only(left: 20),
                                        child: Text(
                                            '• Clear expectation about your project or deliverables'),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('0'),
                                              Text('Proposals')
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('8'),
                                              Text('Messages')
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('2'),
                                              Text('Hired')
                                            ],
                                          ),
                                        ],
                                      ),
                                    ]),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  showModalBottomSheet<void>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Container(
                                        height: 350,
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            // mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                style: ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    minimumSize: const Size(
                                                        double.infinity, 0),
                                                    shape:
                                                        const RoundedRectangleBorder()),
                                                child: const Text(
                                                    'View Proposals'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                style: ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    minimumSize: const Size(
                                                        double.infinity, 0),
                                                    shape:
                                                        const RoundedRectangleBorder()),
                                                child:
                                                    const Text('View messages'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                style: ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    minimumSize: const Size(
                                                        double.infinity, 0),
                                                    shape:
                                                        const RoundedRectangleBorder()),
                                                child: const Text('View hired'),
                                              ),
                                              const Divider(
                                                thickness: 2,
                                                indent: 10,
                                                endIndent: 10,
                                                color: Colors.black,
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                style: ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    minimumSize: const Size(
                                                        double.infinity, 0),
                                                    shape:
                                                        const RoundedRectangleBorder()),
                                                child: const Text(
                                                    'View job posting'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                style: ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    minimumSize: const Size(
                                                        double.infinity, 0),
                                                    shape:
                                                        const RoundedRectangleBorder()),
                                                child:
                                                    const Text('Edit posting'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                style: ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    minimumSize: const Size(
                                                        double.infinity, 0),
                                                    shape:
                                                        const RoundedRectangleBorder()),
                                                child: const Text(
                                                    'Remove posting'),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: const CircleBorder()),
                                child: const Text('...'),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    ),
                    const Center(child: Text('Tab 3 content')),
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
