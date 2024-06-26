import 'dart:convert';
import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/index.dart';
import 'package:studenthub/components/profile_input/language_item.dart';
import 'package:studenthub/config/config.dart';
import 'package:studenthub/models/education_model.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/models/language_model.dart';
import 'package:studenthub/utils/font.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class ViewCandidateSceen extends StatefulWidget {
  final int? candidateId;
  final dynamic candidateData;

  const ViewCandidateSceen({super.key, this.candidateId, this.candidateData});

  @override
  ViewCandidateSceenState createState() => ViewCandidateSceenState();
}

class ViewCandidateSceenState extends State<ViewCandidateSceen> {
  bool isLoading = true;
  bool isResumeLoading = true;
  bool isTranscriptLoading = true;
  late String candidateName = 'Luu Minh Phat';
  dynamic proposalCandidate;
  final List<SkillSet> studentSelectedSkills = [];
  final List<Education> studentSelectedEducations = [];
  final List<Language> studentLanguages = [
    Language(id: 697, languageName: "English", level: "High"),
    Language(id: 698, languageName: "Japanese", level: "Low"),
  ];
  String? _linkResume;
  String? _linkTranscript;

  late Map<int, bool> isCheckedList;

  @override
  void initState() {
    super.initState();
    print(widget.candidateData);
    // print('Data: ${widget.candidateData}');
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
      fileExtention = getFileExtension(widget.candidateData['student']['resume']);
      setState(() {
        isResumeLoading = true;
      });
    } else {
      fileUrl = _linkTranscript!;
      fileName = 'transcript';
      fileExtention = getFileExtension(widget.candidateData['student']['transcript']);
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
    final directory =
        await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    print('Direc: $directory');
    final filePath = '$directory/$fileDefault';
    print(filePath);

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

    print(widget.candidateId);

    try {
      final response = await http.get(
        Uri.parse('$uriBase/api/proposal/${widget.candidateId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      // print(response.body);
      proposalCandidate = jsonDecode(response.body)["result"];
      print(proposalCandidate);

      final List<dynamic> educationsJson = proposalCandidate['student']['educations'];
      print(educationsJson);
      studentSelectedEducations.clear();
      studentSelectedEducations.addAll(educationsJson.map((edu) => Education.fromJson(edu)));

      final List<dynamic> skillsJson = proposalCandidate['student']['skillSets'];
      print(skillsJson);
      studentSelectedSkills.clear();
      studentSelectedSkills.addAll(skillsJson.map((skill) => SkillSet.fromJson(skill)));

      candidateName = widget.candidateData['student']['user']['fullname'];

      if (proposalCandidate != null) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error1: $e');
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
      print('Error2: $e');
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
      print('Error3: $e');
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
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const AuthAppBar(
        title: 'Candidate',
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
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: Text(
                                  getInitials(candidateName),
                                  style: const TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
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
                                          color: Colors.white),
                                    ),
                                    Text(
                                      '${proposalCandidate['student']['techStack']!['name']}',
                                      style: TextStyle(
                                        fontSize: AppFonts.h1_2FontSize,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white.withOpacity(0.8),
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
                      Text(
                        'Educations',
                        style: TextStyle(
                            fontSize: AppFonts.h1_2FontSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          color: Theme.of(context).colorScheme.primary,
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
                                        color: Colors.white),
                                  ),
                                ]
                              : studentSelectedEducations.map(
                                  (edu) {
                                    return Text(
                                      '${edu.startYear.year} - ${edu.endYear != null ? edu.endYear!.year : 'On going'}: \t ${edu.schoolName}',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: AppFonts.h2FontSize,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).colorScheme.surface),
                                    );
                                  },
                                ).toList(),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Languages',
                        style: TextStyle(
                            fontSize: AppFonts.h1_2FontSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: studentLanguages.isEmpty
                                ? [
                                    Text(
                                      'No education is provided',
                                      maxLines: 1,
                                      style: TextStyle(
                                          fontSize: AppFonts.h3FontSize,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).colorScheme.surface),
                                    ),
                                  ]
                                : studentLanguages.map(
                                    (lan) {
                                      return LanguageItem(
                                        language: lan,
                                        handleDelete: () {},
                                        hideDelete: true,
                                      );
                                    },
                                  ).toList(),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Skills',
                        style: TextStyle(
                            fontSize: AppFonts.h1_2FontSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).colorScheme.primary, width: 1),
                                borderRadius: BorderRadius.circular(9),
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              child: Wrap(
                                spacing: 8.0, // Adjust the spacing between items
                                runSpacing: 8.0, // Adjust the spacing between lines
                                children: studentSelectedSkills.isEmpty
                                    ? [
                                        SizedBox(
                                          height: 50, // Set your desired height here
                                          child: Center(
                                            child: Text(
                                              'No skill is selected',
                                              style: TextStyle(
                                                  color: Theme.of(context).colorScheme.onSurface,
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
                      Text(
                        'Cover Letter',
                        style: TextStyle(
                            fontSize: AppFonts.h1_2FontSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 250,
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Theme.of(context).colorScheme.primary, width: 1),
                                borderRadius: BorderRadius.circular(9),
                                color: Theme.of(context).colorScheme.surface,
                              ),
                              child: SingleChildScrollView(
                                  child: Text(
                                '${widget.candidateData['coverLetter']}',
                                style: TextStyle(
                                    fontSize: AppFonts.h2FontSize,
                                    color: Theme.of(context).colorScheme.onSurface),
                              )),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Download Files',
                        style: TextStyle(
                            fontSize: AppFonts.h1_2FontSize,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary),
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
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(
                                      _linkResume != null
                                          ? Icons.download
                                          : Icons.file_download_off,
                                      color: Colors.white,
                                    ),
                              label: const Text(
                                'Resume',
                                style:
                                    TextStyle(color: Colors.white, fontSize: AppFonts.h3FontSize),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Theme.of(context).colorScheme.primary),
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
                                        color: Colors.white,
                                      ),
                                    )
                                  : Icon(
                                      _linkTranscript != null
                                          ? Icons.download
                                          : Icons.file_download_off,
                                      color: Colors.white,
                                    ),
                              label: const Text(
                                'Transcript',
                                style:
                                    TextStyle(color: Colors.white, fontSize: AppFonts.h3FontSize),
                              ),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    Theme.of(context).colorScheme.primary),
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
