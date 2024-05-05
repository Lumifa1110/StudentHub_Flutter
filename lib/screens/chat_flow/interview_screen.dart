import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/config/config.dart';
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';

class InterviewScreen extends StatefulWidget {
  final String conferenceId;

  const InterviewScreen({super.key, required this.conferenceId});

  @override
  State<InterviewScreen> createState() => _InterviewScreenState();
}

class _InterviewScreenState extends State<InterviewScreen> {
  int userId = 0;
  String userName = '';

  @override
  initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getInt('userid')!;
      userName = prefs.getString('username')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltVideoConference(
        appID: zegoAppId,
        appSign: zegoAppSign,
        conferenceID: widget.conferenceId,
        userID: userId.toString(),
        userName: userName,
        config: ZegoUIKitPrebuiltVideoConferenceConfig());
  }
}
