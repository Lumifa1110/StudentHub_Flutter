import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/index.dart';
import 'package:studenthub/config/config.dart';
import 'package:studenthub/models/education_model.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/services/api_services.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class ViewCandidateSceen extends StatefulWidget {
  final int? candidateId;

  const ViewCandidateSceen({super.key, this.candidateId});

  @override
  _ViewCandidateSceenState createState() => _ViewCandidateSceenState();
}

class _ViewCandidateSceenState extends State<ViewCandidateSceen> {
  bool isLoading = true;
  bool isResumeLoading = true;
  bool isTranscriptLoading = true;
  late String candidateName = 'Luu Minh Phat';
  dynamic proposalCandidate;
  final List<SkillSet> studentSelectedSkills = [
    SkillSet(id: 1, name: 'C'),
    SkillSet(id: 2, name: 'C++'),
    SkillSet(id: 3, name: 'C#'),
    SkillSet(id: 3, name: 'JavaScript'),
  ];
  final List<Education> studentSelectedEducations = [];
  String? _linkResume;
  String? _linkTranscript;

  late Map<int, bool> isCheckedList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchCandidateProposal().then((value) => {
          _fetchResumeLink(),
          _fetchTranscriptLink(),
        });
  }

  String getFileExtension(String url) {
    return path.extension(Uri.parse(url).path);
  }

  Future<void> _downloadFile(bool isResume) async {
    String fileUrl = "";
    String fileExtention = "";
    String fileName = "";
    String fileDefault = "";

    if (isResume) {
      fileUrl = _linkResume!;
      fileName = 'resume';
      fileExtention = getFileExtension(proposalCandidate['student']['resume']);
      setState(() {
        isResumeLoading = true;
      });
    } else {
      fileUrl = _linkTranscript!;
      fileName = 'transcript';
      fileExtention = getFileExtension(proposalCandidate['student']['transcript']);
      setState(() {
        isTranscriptLoading = true;
      });
    }
    fileDefault = fileName + fileExtention;
    print(fileDefault);

    final request = await HttpClient().getUrl(Uri.parse(fileUrl));
    final response = await request.close();
    final bytes = await consolidateHttpClientResponseBytes(response);

    // Get the directory where the file will be saved
    final directory = (await getDownloadsDirectory());
    print('Direc: $directory');
    final filePath = '/storage/emulated/0/Download/$fileDefault';

    // Write the file to disk
    final File file = File(filePath);
    await file.writeAsBytes(bytes);

    setState(() {
      isResumeLoading = false;
      isTranscriptLoading = false;
    });

    // Show a message or perform any action after the file is downloaded
    print('File downloaded to: $filePath');
  }

  Future<void> _fetchCandidateProposal() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('$uriBase/api/proposal/${widget.candidateId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      print(response.body);
      proposalCandidate = jsonDecode(response.body)["result"];

      final List<dynamic> educationsJson = proposalCandidate['student']['educations'];
      studentSelectedEducations.clear();
      studentSelectedEducations.addAll(educationsJson.map((edu) => Education.fromJson(edu)));

      if (proposalCandidate != null) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchResumeLink() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('$uriBase/api/profile/student/${proposalCandidate["studentId"]}/resume'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);

        _linkResume = jsonResponse['result'];

        setState(() {
          isResumeLoading = false;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _fetchTranscriptLink() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await http.get(
        Uri.parse('$uriBase/api/profile/student/${proposalCandidate["studentId"]}/transcript'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        var jsonResponse = jsonDecode(response.body);

        _linkTranscript = jsonResponse['result'];

        setState(() {
          isTranscriptLoading = false;
        });
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  String getInitials(String name) {
    List<String> nameParts = name.split(' ');
    if (nameParts.length == 1) {
      return nameParts[0].substring(0, 1).toUpperCase();
    } else {
      String firstInitial = nameParts[0].substring(0, 1).toUpperCase();
      String lastInitial = nameParts[nameParts.length - 1].substring(0, 1).toUpperCase();
      return '$firstInitial$lastInitial';
    }
  }

  void removeSelectedSkills(int id) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteTextColor,
      appBar: const AuthAppBar(
        canBack: true,
        isShowIcon: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: mainColor,
                        ),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: blackTextColor,
                                child: Text(
                                  getInitials(candidateName),
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.tertiary,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 8,
                              child: Container(
                                margin: const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      candidateName,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: AppFonts.h1FontSize,
                                          fontWeight: FontWeight.bold,
                                          color: whiteTextColor),
                                    ),
                                    Text(
                                      '${proposalCandidate['student']['techStack']!['name']}',
                                      style: TextStyle(
                                        fontSize: AppFonts.h1_2FontSize,
                                        fontWeight: FontWeight.w500,
                                        color: lightestgrayColor.withOpacity(0.8),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Education',
                        style: TextStyle(
                            fontSize: AppFonts.h1_2FontSize,
                            fontWeight: FontWeight.bold,
                            color: mainColor),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: mainColor,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: studentSelectedEducations.isEmpty
                              ? [
                                  const Text(
                                    'No education is provided',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: AppFonts.h3FontSize,
                                        fontWeight: FontWeight.w500,
                                        color: whiteTextColor),
                                  ),
                                ]
                              : studentSelectedEducations.map(
                                  (edu) {
                                    return Text(
                                      '${edu.startYear.year} - ${edu.endYear != null ? edu.endYear!.year : 'On going'}: \t ${edu.schoolName}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontSize: AppFonts.h3FontSize,
                                          fontWeight: FontWeight.w500,
                                          color: whiteTextColor),
                                    );
                                  },
                                ).toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'SkillSet',
                        style: TextStyle(
                            fontSize: AppFonts.h1_2FontSize,
                            fontWeight: FontWeight.bold,
                            color: mainColor),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                border: Border.all(color: mainColor, width: 1),
                                borderRadius: BorderRadius.circular(9),
                              ),
                              child: Wrap(
                                spacing: 8.0, // Adjust the spacing between items
                                runSpacing: 8.0, // Adjust the spacing between lines
                                children: studentSelectedSkills.isEmpty
                                    ? [
                                        const SizedBox(
                                          height: 50, // Set your desired height here
                                          child: Center(
                                            child: Text(
                                              'No skill is selected',
                                              style: TextStyle(
                                                  color: blackTextColor,
                                                  fontSize: AppFonts.h3FontSize),
                                            ),
                                          ),
                                        ),
                                      ]
                                    : studentSelectedSkills.map((skillset) {
                                        return BoxSkillset(
                                          id: skillset.id,
                                          text: skillset.name,
                                          onDelete: removeSelectedSkills,
                                          hideDelete: true,
                                        );
                                      }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Download Files',
                        style: TextStyle(
                            fontSize: AppFonts.h1_2FontSize,
                            fontWeight: FontWeight.bold,
                            color: mainColor),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _linkResume != null && !isResumeLoading
                                  ? () => _downloadFile(true)
                                  : null,
                              icon: isResumeLoading
                                  ? const SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        color: whiteTextColor,
                                      ),
                                    )
                                  : Icon(
                                      _linkResume != null
                                          ? Icons.download
                                          : Icons.file_download_off,
                                      color: whiteTextColor,
                                    ),
                              label: const Text(
                                'Resume',
                                style:
                                    TextStyle(color: whiteTextColor, fontSize: AppFonts.h3FontSize),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(mainColor),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _linkTranscript != null && !isTranscriptLoading
                                  ? () => _downloadFile(false)
                                  : null,
                              icon: isTranscriptLoading
                                  ? const SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                        color: whiteTextColor,
                                      ),
                                    )
                                  : Icon(
                                      _linkTranscript != null
                                          ? Icons.download
                                          : Icons.file_download_off,
                                      color: whiteTextColor,
                                    ),
                              label: const Text(
                                'Transcript',
                                style:
                                    TextStyle(color: whiteTextColor, fontSize: AppFonts.h3FontSize),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(mainColor),
                                // Kích thước của nút
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
