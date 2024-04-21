import 'package:flutter/material.dart';

class ViewCandidateSceen extends StatefulWidget {
  const ViewCandidateSceen({Key? key}) : super(key: key);

  @override
  _ViewCandidateSceenState createState() => _ViewCandidateSceenState();
}

class _ViewCandidateSceenState extends State<ViewCandidateSceen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [],
            )),
      ),
    );
  }
}
