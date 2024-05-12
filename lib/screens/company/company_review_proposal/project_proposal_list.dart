import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/project_proposal/index.dart';
import 'package:studenthub/utils/font.dart';
import 'package:studenthub/config/config.dart';
import 'package:http/http.dart' as http;

import '../../../utils/timer.dart';

class ProjectProposalListScreen extends StatefulWidget {
  final dynamic project;
  const ProjectProposalListScreen({super.key, required this.project});

  @override
  State<ProjectProposalListScreen> createState() => _ProjectProposalListScreenState();
}

class _ProjectProposalListScreenState extends State<ProjectProposalListScreen> {
  late SharedPreferences _prefs;
  late dynamic _proposal;
  bool isLoading = true;
  String errorMessage = '';
  late dynamic _listItemsHired;

  @override
  void initState() {
    super.initState();
    _loadProposals().then((_) => _loadHired()).then((_) => setState(() {
          isLoading = false;
        }));
  }

  Future<void> _loadProposals() async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    try {
      final responseJson = await http.get(
        Uri.parse('$uriBase/api/proposal/getByProjectId/${widget.project['id']}'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final responseDecode = jsonDecode(responseJson.body)["result"];
      if (responseDecode != null) {
        _proposal = responseDecode;
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

  Future<void> _loadHired() async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    try {
      final responseJson = await http.get(
        Uri.parse(
            '$uriBase/api/proposal/getByProjectId/${widget.project['id']}?limit=100&statusFlag=3'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final responseDecode = jsonDecode(responseJson.body)["result"];

      if (responseDecode != null) {
        _listItemsHired = responseDecode;
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
    return Scaffold(
      appBar: const AuthAppBar(canBack: true),
      body: DefaultTabController(
        length: 3,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : Container(
                    color: Theme.of(context).colorScheme.background,
                    child: Column(
                      children: [
                        // Project name
                        Container(
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 2))
                          ]),
                          padding: const EdgeInsets.only(top: 20, bottom: 12, left: 20),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            // Project Name
                            Text(widget.project['title'],
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: AppFonts.h1FontSize,
                                    fontWeight: FontWeight.bold)),
                            // Project post time
                            Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              child: Text(
                                  'Created ${timeSinceCreated(widget.project['createdAt'])}',
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.onSurface,
                                      fontSize: AppFonts.h4FontSize,
                                      fontWeight: FontWeight.w400)),
                            ),
                            // Project proposal stats
                            Container(
                              margin: const EdgeInsets.only(bottom: 6),
                              child: Text('Status:',
                                  style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontSize: AppFonts.h3FontSize,
                                      fontWeight: FontWeight.w400)),
                            ),
                            // Number of proposals
                            Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              child: Row(children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: 14,
                                  margin: const EdgeInsets.only(right: 6),
                                  child: const FaIcon(FontAwesomeIcons.idCardClip, size: 12),
                                ),
                                Text('Proposals - ${_proposal['items'].length}',
                                    style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface,
                                        fontSize: AppFonts.h3FontSize,
                                        fontWeight: FontWeight.w400)),
                              ]),
                            ),
                            // Number of messages
                            Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              child: Row(children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: 14,
                                  margin: const EdgeInsets.only(right: 6),
                                  child: const FaIcon(FontAwesomeIcons.message, size: 12),
                                ),
                                Text('Messages - ${widget.project['countMessages']}',
                                    style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface,
                                        fontSize: AppFonts.h3FontSize,
                                        fontWeight: FontWeight.w400)),
                              ]),
                            ),
                            // Number of hired students
                            Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              child: Row(children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: 14,
                                  margin: const EdgeInsets.only(right: 6),
                                  child: const FaIcon(FontAwesomeIcons.user, size: 12),
                                ),
                                Text('Hired - ${_listItemsHired['items'].length}',
                                    style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface,
                                        fontSize: AppFonts.h3FontSize,
                                        fontWeight: FontWeight.w400)),
                              ]),
                            ),
                          ]),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: TabBar(
                            labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: AppFonts.h3FontSize),
                            unselectedLabelStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                            tabs: const [
                              Tab(text: 'Proposals'),
                              Tab(text: 'Detail'),
                              Tab(text: 'Hire'),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: ClipRect(
                              child: TabBarView(children: [
                                _proposal['items'].length == 0
                                    ? const Center(
                                        child: Text('These aren\'t Proposals yet'),
                                      )
                                    : SingleChildScrollView(
                                        child: ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: _proposal['items'].length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return _proposal['items'][index]['statusFlag'] != 3 ? ProjectProposalItem(
                                                  itemsProposal: _proposal['items'][index]): _proposal['items'].length == 1?const Center(
                                                child: Text('These aren\'t Proposals yet'),
                                              ): null;
                                            }),
                                      ),
                                ProjectDetailTab(
                                  project: widget.project,
                                ),
                                _listItemsHired['items'].length == 0
                                    ? const Center(
                                        child: Text('These aren\'t Hirings yet'),
                                      )
                                    : SingleChildScrollView(
                                        child: ListView.builder(
                                            physics: const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: _listItemsHired['items'].length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return ProjectHiredStudentItem(
                                                  itemsProposal: _listItemsHired['items'][index]);
                                            }),
                                      ),
                              ]),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
      ),
    );
  }
}
