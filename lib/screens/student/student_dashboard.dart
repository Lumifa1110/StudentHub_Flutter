import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

import '../../utils/mock_data.dart';

class StudentDashboardScreen extends StatefulWidget {
  const StudentDashboardScreen({super.key});

  @override
  State<StudentDashboardScreen> createState() => _StudentDashboardScreenState();
}

class _StudentDashboardScreenState extends State<StudentDashboardScreen> {
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadScreen();
  }

  Future<void> _loadScreen() async {
    _prefs = await SharedPreferences.getInstance();
    final role = _prefs.getInt('current_role');
    print(role);
    if (role == 0) {
      final profile = _prefs.getString('student_profile');
      if (profile == 'null') {
        Navigator.pushReplacementNamed(context, '/student');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/company/dashboard');
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Your projects',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                        text: 'Working',
                      ),
                      Tab(
                        text: 'Archieved',
                      )
                    ]),
              ),
              Expanded(
                child: TabBarView(children: [
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                            flex: 1,
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(border: Border.all()),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Active proposal(0)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppFonts.h3FontSize),
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount:
                                          0, // Number of items in your list
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final proposal = mockProposal[index];
                                        // itemBuilder builds each item in the list
                                        return OptionItemAllProjectScreen(
                                            onTap: () {}, proposal: proposal);
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
                              decoration: BoxDecoration(border: Border.all()),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Submitted proposal(${mockProposal.length})',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppFonts.h3FontSize),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: mockProposal
                                          .length, // Number of items in your list
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final proposal = mockProposal[index];
                                        return OptionItemAllProjectScreen(
                                            onTap: () {}, proposal: proposal);
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
                              itemCount: 1,
                              itemBuilder: (context, index) {
                                final proposal = mockProposal[index];
                                return OptionItemWorkingScreen(
                                    onTap: () {}, proposal: proposal);
                              }),
                        ),
                      ],
                    ),
                  ),
                  const Center(child: Text('Tab 3 content')),
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
  final Proposal proposal;

  const OptionItemAllProjectScreen({
    super.key,
    required this.onTap,
    required this.proposal,
  });

  @override
  State<OptionItemAllProjectScreen> createState() =>
      _OptionItemAllProjectScreenState();
}

class _OptionItemAllProjectScreenState
    extends State<OptionItemAllProjectScreen> {
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
              widget.proposal.position,
              style: const TextStyle(color: Colors.green),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Submitted ${widget.proposal.postingTime} days ago',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('Students are looking for'),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('• ${widget.proposal.description[0]}'),
            ),
            const Divider(
              height: 60,
              endIndent: 10,
              thickness: 2,
            )
          ],
        ),
      ),
    );
  }
}

class OptionItemWorkingScreen extends StatefulWidget {
  final VoidCallback onTap;
  final Proposal proposal;

  const OptionItemWorkingScreen({
    super.key,
    required this.onTap,
    required this.proposal,
  });

  @override
  State<OptionItemWorkingScreen> createState() =>
      _OptionItemWorkingScreenState();
}

class _OptionItemWorkingScreenState extends State<OptionItemWorkingScreen> {
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
              widget.proposal.position,
              style: const TextStyle(color: Colors.green),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Time ${widget.proposal.executionTime}, ${widget.proposal.numberOfStudents} students',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('Students are looking for'),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('• ${widget.proposal.description[0]}'),
            ),
            const Divider(
              height: 60,
              endIndent: 10,
              thickness: 2,
            )
          ],
        ),
      ),
    );
  }
}
