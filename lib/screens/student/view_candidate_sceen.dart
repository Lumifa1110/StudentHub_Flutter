import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studenthub/utils/colors.dart';

class ViewCandidateSceen extends StatefulWidget {
  const ViewCandidateSceen({Key? key}) : super(key: key);

  @override
  _ViewCandidateSceenState createState() => _ViewCandidateSceenState();
}

class _ViewCandidateSceenState extends State<ViewCandidateSceen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mainColor,
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: whiteTextColor,
                  padding: EdgeInsets.all(5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            icon: const Icon(
                              Icons.chevron_left,
                              color: mainColor,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: blackTextColor,
                        backgroundImage:
                            AssetImage('assets/images/smileyface.png'),
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
