import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: mainColor,
            title: const Row(
              children: [
                const Text(
                  'Student',
                  style: TextStyle(color: Colors.white),
                ),
                const Text(
                  'Hub  ',
                ),
                Spacer(),
                Icon(Icons.person)
              ],
            ),
          ),
          body: Center(
              child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Buil your product with high-skilled student',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Find and onboard best-skilled student for your product. Student works to gain experience & skills from real-world project',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 40,
                ),
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(),
                        fixedSize: Size(150, 40)),
                    child: const Text("Company")),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(),
                      fixedSize: Size(150, 40),
                    ),
                    child: const Text("Student")),
                SizedBox(
                  height: 40,
                ),
                Text(
                  'StudentHub is university market place to connect high-skilled student and company on a real-world project',
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ))),
    );
  }
}
