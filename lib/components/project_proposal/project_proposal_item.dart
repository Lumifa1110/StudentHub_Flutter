import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/project_proposal/dialog_send_hire.dart';
import 'package:studenthub/components/user/user_avatar.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/screens/chat_flow/index.dart';
import 'package:studenthub/screens/student/view_candidate_sceen.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';
import 'package:http/http.dart' as http;
import 'package:studenthub/config/config.dart';

class ProjectProposalItem extends StatefulWidget {
  final dynamic itemsProposal;

  const ProjectProposalItem({super.key, required this.itemsProposal});

  @override
  State<ProjectProposalItem> createState() => _ProjectProposalItemState();
}

class _ProjectProposalItemState extends State<ProjectProposalItem> {
  late bool sentHireOffer;
  late SharedPreferences _prefs;
  late String? _token;

  Future<void> declarePrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    declarePrefs().then((_) => _token = _prefs.getString('token'));
    print('Proposal data: ${widget.itemsProposal['student']['userId']}');
    sentHireOffer = widget.itemsProposal['statusFlag'] == 2
        ? true
        : widget.itemsProposal['statusFlag'] == 3
            ? true
            : false;
  }

  Future<void> sendHireOffer() async {
    final Map<String, dynamic> data = {
      'statusFlag': 2,
      'disableFlag': 0,
    };
    try {
      final response = await http.patch(
        Uri.parse('$uriBase/api/proposal/${widget.itemsProposal['id']}'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          sentHireOffer = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }
  Future<void> messageCandidate() async {
    final Map<String, dynamic> data = {
      'statusFlag': 1,
      'disableFlag': 0,
    };
    try {
      final response = await http.patch(
        Uri.parse('$uriBase/api/proposal/${widget.itemsProposal['id']}'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MessageDetailScreen(
                          projectId: widget.itemsProposal['projectId'],
                          chatter: Chatter(
                              id: widget.itemsProposal['student']['userId'],
                              fullname: widget
                                  .itemsProposal['student']['user']['fullname']
                          )
                      )
              )
          );
        }
      }
    }catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.only(bottom: 8, left: 12, right: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.black12),
        ),
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewCandidateSceen(
                  candidateId: widget.itemsProposal['id'],
                  candidateData: widget.itemsProposal,
                ),
              ),
            );
          },
          child: Column(
            children: [
              // Student avatar and information
              Row(children: [
                // Student Avatar
                const Expanded(flex: 1, child: UserAvatar(icon: Icons.person)),
                // Student Name + Educational level
                Expanded(
                    flex: 8,
                    child: Container(
                      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 10),
                      height: 70,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.itemsProposal['student']['user']['fullname'],
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontSize: AppFonts.h2FontSize,
                                    fontWeight: FontWeight.w500)),
                            Text('Excellent',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontSize: AppFonts.h3FontSize,
                                    fontWeight: FontWeight.w400)),
                          ]),
                    ))
              ]),
              // Student Techstack + Rating status
              Container(
                margin: const EdgeInsets.only(top: 4, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(widget.itemsProposal['student']['techStack']['name']!,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: AppFonts.h3FontSize,
                            fontWeight: FontWeight.w500)),
                    const Text('Excellent',
                        style: TextStyle(
                            color: Colors.deepOrangeAccent,
                            fontSize: AppFonts.h3FontSize,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
              // Proposal Comment
              Row(children: [
                Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.black12)),
                        margin: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          widget.itemsProposal['coverLetter'],
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface, fontSize: AppFonts.h3FontSize),
                        )))
              ]),
              // Buttons
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          if(widget.itemsProposal['statusFlag']<1){
                            messageCandidate();
                          }
                          else{
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MessageDetailScreen(
                                        projectId: widget.itemsProposal['projectId'],
                                        chatter: Chatter(
                                            id: widget.itemsProposal['student']['userId'],
                                            fullname: widget.itemsProposal['student']['user']['fullname']
                                        )
                                    )
                                )
                            );
                          }
                        },
                        child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(6)),
                            child: const Text('Message',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: AppFonts.h3FontSize,
                                    fontWeight: FontWeight.w500))),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          if(!sentHireOffer){
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DialogSendHire(sendHireOffer: sendHireOffer);
                              },
                            );
                          }
                          else{
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('Notification!'),
                                content: const Text('You have sent an offer to the candidate.'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: Container(
                            alignment: Alignment.center,
                            margin: const EdgeInsets.only(left: 12),
                            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                            decoration: BoxDecoration(
                                color: AppColor.tertiary, borderRadius: BorderRadius.circular(6)),
                            child: Text(sentHireOffer ? 'Sent hired offer' : 'Hire',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: AppFonts.h3FontSize,
                                    fontWeight: FontWeight.w500))),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
