import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';
import 'package:http/http.dart' as http;

import '../../business/company_business.dart';
import '../../config/config.dart';
import '../../models/notification_model.dart';
import '../shared/notification_screen.dart';

class ViewOfferScreen extends StatefulWidget {
  final NotificationModel notification;
  final dynamic response;

  const ViewOfferScreen({super.key, required this.notification, required this.response});

  @override
  State<ViewOfferScreen> createState() => _ViewOfferScreenState();
}

class _ViewOfferScreenState extends State<ViewOfferScreen> {
  late bool isStudent = true;
  late SharedPreferences _prefs;
  late final _token;

  Future<void> _loadingScreen() async {
    _prefs = await SharedPreferences.getInstance();
    _token = _prefs.getString('token');
  }

  @override
  void initState() {
    super.initState();
    _loadingScreen();
  }

  Future<void> acceptOffer() async {
    final Map<String, dynamic> data = {
      'statusFlag': 3,
      'disableFlag': 0,
    };
    try {
      final response = await http.patch(
        Uri.parse('$uriBase/api/proposal/${widget.notification.proposalId}'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {}
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const AuthAppBar(canBack: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  '${widget.response['title']}',
                  style: TextStyle(
                    fontSize: AppFonts.h1FontSize,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '  Project',
                style: TextStyle(
                  fontSize: AppFonts.h1_2FontSize,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text('Title: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text('${widget.response['proposal']['project']['title']}')
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Number of students: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('${widget.response['proposal']['project']['numberOfStudents']}'),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Project Scope: ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Expanded(
                              child: Text(convertProjectScoreFlagToTime(
                                  widget.response['proposal']['project']['numberOfStudents']))),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Description: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                '${widget.response['proposal']['project']['description']}',
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '  Proposal',
                style: TextStyle(
                  fontSize: AppFonts.h1_2FontSize,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Name: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: Text(widget.response['receiver']['fullname'])),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Cover Letter: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                          ),
                          Expanded(
                              child: Text(
                            '${widget.response['proposal']['coverLetter']}',
                            overflow: TextOverflow.ellipsis,
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Skill: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                              child: Text(
                            '${widget.response['proposal']['student']['techStack']['name']}',
                            overflow: TextOverflow.ellipsis,
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                '  Party',
                style: TextStyle(
                  fontSize: AppFonts.h1_2FontSize,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Sender: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(child: Text(widget.response['sender']['email'])),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Text(
                            'Receiver: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Expanded(
                              child: Text(
                            '${widget.response['receiver']['email']}',
                            overflow: TextOverflow.ellipsis,
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Content: ',
                style: TextStyle(
                  fontSize: AppFonts.h1_2FontSize,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  'Dear ${widget.response['receiver']['fullname']}.\n ${widget.response['content']}. \n   Your receipt of this offer is a result of your hard work and expertise in the field you study and work in. The company has seen potential and drive in you and believes that you will make a positive contribution to their ${widget.response['proposal']['project']['title']}project.\n   If you wish to join this project, we encourage you to accept the offer promptly. This will open up opportunities for you to develop your skills, build relationships in the industry, and contribute to an exciting and meaningful project.\n   If you have any questions about the offer or the working process, please do not hesitate to contact us. We are more than happy to assist you and provide any necessary information to help you make the most informed decision.\n   We look forward to working with you in the near future!\n   Best regards,\n     ${widget.response['sender']['fullname']} ',
                  style: TextStyle(
                      fontSize: AppFonts.h3FontSize,
                      color: Theme.of(context).colorScheme.onSurface),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isStudent
                      ? Container(
                          width: 180,
                          height: 40,
                          padding: const EdgeInsets.all(0),
                          decoration: BoxDecoration(
                            border: Border.all(color: blackTextColor, width: 2.0),
                            color: whiteTextColor,
                            boxShadow: const [
                              BoxShadow(
                                color: blackTextColor,
                                offset: Offset(2, 3),
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                color: blackTextColor,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Container(
                    width: 180,
                    height: 40,
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      border: Border.all(color: blackTextColor, width: 2.0),
                      color: whiteTextColor,
                      boxShadow: const [
                        BoxShadow(
                          color: blackTextColor,
                          offset: Offset(2, 3),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        if (widget.notification.proposal!.statusFlag != 3) {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Success'),
                              content: const Text('Accept the offer successful.'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const NotificationScreen()),
                                        (route) => false);
                                    acceptOffer();
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Notification!'),
                              content: const Text('You have accepted the offer.'),
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
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                        ),
                      ),
                      child: Text(
                        widget.notification.proposal!.statusFlag == 3 ? 'Accepted' : 'Accept',
                        style: const TextStyle(
                          fontSize: 16,
                          color: blackTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
