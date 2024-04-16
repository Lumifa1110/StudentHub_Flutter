import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/project_proposal/index.dart';
import 'package:studenthub/data/test/data_student.dart';
import 'package:studenthub/models/company_model.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';
import 'package:studenthub/config/config.dart';
import 'package:http/http.dart' as http;



class ProjectProposalListScreen extends StatefulWidget {
  final Project project;
  const ProjectProposalListScreen({super.key, required this.project});


  @override
  State<ProjectProposalListScreen> createState() => _ProjectProposalListScreenState();
}

class _ProjectProposalListScreenState extends State<ProjectProposalListScreen> {
  late SharedPreferences _prefs;
  late final Proposal _proposal;
  bool isLoading = true;
  String errorMessage = '';
  List<ItemsProposal> listItemsHired = [];


  @override
  void initState(){
    super.initState();
    _loadProposals().then((value) => _loadHired());
  }
  Future<List<ItemsProposal>> processData(Map<String, dynamic> responseDecode) async{
    List<ItemsProposal>listItemsProposal = [];
    if (responseDecode['total'] ==0) {
      return listItemsProposal;
    }
    for(int i = 0; i < responseDecode['items'].length; i++){
      TechStack techStack =  TechStack(id: responseDecode['items'][0]['student']['techStack']['id'], name: responseDecode['items'][0]['student']['techStack']['name']);
      Student student =  Student(id: responseDecode['items'][0]['student']['id'], fullname: responseDecode['items'][0]['student']['user']['fullname'], techStack: techStack);
      ItemsProposal itemsProposal = ItemsProposal(id: responseDecode['items'][0]['id'], coverLetter: responseDecode['items'][0]['coverLetter'], statusFlag: responseDecode['items'][0]['statusFlag'], disableFlag: responseDecode['items'][0]['disableFlag'], student: student);
      listItemsProposal.add(itemsProposal);
    }
    return listItemsProposal;
  }
  Future<void> _loadProposals() async{
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    try {
      final responseJson = await http.get(
        Uri.parse('$uriBase/api/proposal/getByProjectId/${widget.project.projectId}'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final responseDecode = jsonDecode(responseJson.body)["result"];

      List<ItemsProposal>listItemsProposal = await processData(responseDecode) as List<ItemsProposal>;

      _proposal = Proposal(total: responseDecode['total'] , items: listItemsProposal);
      // print(responseDecode['items'][0]['disableFlag'].runtimeType);
      // print(responseDecode['items'][0]);
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

  Future<void> _loadHired() async{
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    try {
      final responseJson = await http.get(
        Uri.parse('$uriBase/api/proposal/getByProjectId/${widget.project.projectId}?limit=100&statusFlag=2'),
        headers: {'Authorization': 'Bearer $token'},
      );
      final responseDecode = jsonDecode(responseJson.body)["result"];
      for(int i = 0; i < responseDecode['total']; i++)
        {
          TechStack techStack =  TechStack(id: responseDecode['items'][0]['student']['techStack']['id'], name: responseDecode['items'][0]['student']['techStack']['name']);
          Student student =  Student(id: responseDecode['items'][0]['student']['id'], fullname: responseDecode['items'][0]['student']['user']['fullname'], techStack: techStack);
          ItemsProposal itemsProposal = ItemsProposal(id: responseDecode['items'][0]['id'], coverLetter: responseDecode['items'][0]['coverLetter'], statusFlag: responseDecode['items'][0]['statusFlag'], disableFlag: responseDecode['items'][0]['disableFlag'], student: student);
          listItemsHired.add(itemsProposal);
        }

      
      // print(responseDecode['items'][0]['disableFlag'].runtimeType);
      // print(responseDecode['items'][0]);
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
    return Scaffold(
      appBar: const AuthAppBar(canBack: true),
      body: DefaultTabController(
        length: 3,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
            ? Center(child: Text(errorMessage))
            :Container(
          color: const Color(0xFFF8F8F8),
          child: Column(
            children: [
              // Project name
              Container(
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 2)
                    )
                  ]
                ),
                padding: const EdgeInsets.only(top: 20, bottom: 12, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project Name
                    Text(
                      widget.project.title,
                      style: const TextStyle(
                        color: AppFonts.primaryColor,
                        fontSize: AppFonts.h1FontSize,
                        fontWeight: FontWeight.w600
                      )
                    ),
                    // Project post time
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: const Text(
                        'created 3 days ago',
                        style: TextStyle(
                          color: AppFonts.secondaryColor,
                          fontSize: AppFonts.h3FontSize,
                          fontWeight: FontWeight.w400
                        )
                      ),
                    ),
                    // Project proposal stats
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      child: const Text(
                        'Status:',
                        style: TextStyle(
                          color: AppColor.primary,
                          fontSize: AppFonts.h3FontSize,
                          fontWeight: FontWeight.w400
                        )
                      ),
                    ),
                    // Number of proposals
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 14,
                            margin: const EdgeInsets.only(right: 6),
                            child: const FaIcon(
                              FontAwesomeIcons.idCardClip,
                              size: 12
                            ),
                          ),
                          Text(
                            'Proposals - ${_proposal.total}',
                            style: const TextStyle(
                              color: AppFonts.primaryColor,
                              fontSize: AppFonts.h3FontSize,
                              fontWeight: FontWeight.w400
                            )
                          ),
                        ]
                      ),
                    ),
                    // Number of messages
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 14,
                            margin: const EdgeInsets.only(right: 6),
                            child: const FaIcon(
                              FontAwesomeIcons.message,
                              size: 12
                            ),
                          ),
                          const Text(
                            'Messages - 8',
                            style: TextStyle(
                              color: AppFonts.primaryColor,
                              fontSize: AppFonts.h3FontSize,
                              fontWeight: FontWeight.w400
                            )
                          ),
                        ]
                      ),
                    ),
                    // Number of hired students
                    Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            width: 14,
                            margin: const EdgeInsets.only(right: 6),
                            child: const FaIcon(
                              FontAwesomeIcons.user,
                              size: 12
                            ),
                          ),
                           Text(
                            'Hired - ${listItemsHired.length}',
                            style: const TextStyle(
                              color: AppFonts.primaryColor,
                              fontSize: AppFonts.h3FontSize,
                              fontWeight: FontWeight.w400
                            )
                          ),
                        ]
                      ),
                    ),
                  ]
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: const TabBar(
                  tabs: [
                    Tab(text: 'Proposals'),
                    Tab(text: 'Detail'),
                    Tab(text: 'Hire'),
                  ]
                )
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ClipRect(
                    child: TabBarView(
                      children: [
                        SingleChildScrollView(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _proposal.total,
                            itemBuilder: (BuildContext context, int index) {
                              return ProjectProposalItem(itemsProposal: _proposal.items[index]);
                            }
                          ),
                        ),
                        ProjectDetailTab(project:widget.project,),
                        SingleChildScrollView(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: listItemsHired.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ProjectHiredStudentItem(
                                itemsProposal: listItemsHired[index]
                              );
                            }
                          ),
                        ),
                      ]
                    ),
                  ),
                ),
              )
            ]
          )
        )
      )
    );
  }
}
