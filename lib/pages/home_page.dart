import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/utils/colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: bgColor,
          appBar: const AuthAppBar(canBack: false),
          body: Center(
              child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Build your product with high-skilled student',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'Find and onboard best-skilled student for your product. Student works to gain experience & skills from real-world project',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  width: 180,
                  height: 45,
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    border: Border.all(color: lightgrayColor, width: 2.0),
                    color: mainColor,
                    boxShadow: const [
                      BoxShadow(
                        color: lightgrayColor,
                        offset: Offset(0, 0),
                        blurRadius: 1.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup/company');
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero),
                      ),
                    ),
                    child: const Text(
                      'Company',
                      style: TextStyle(
                        fontSize: 18,
                        color: whiteTextColor,
                      ),
                    ),
                  ),
                ),
                // ElevatedButton(
                //     onPressed: () {},
                //     style: ElevatedButton.styleFrom(
                //       shape: const RoundedRectangleBorder(),
                //       fixedSize: const Size(150, 40),
                //     ),
                //     child: const Text("Student")),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 180,
                  height: 45,
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    border: Border.all(color: lightgrayColor, width: 2.0),
                    color: mainColor,
                    boxShadow: const [
                      BoxShadow(
                        color: lightgrayColor,
                        offset: Offset(0, 0),
                        blurRadius: 1.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup/student');
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(mainColor),
                    ),
                    child: const Text(
                      'Student',
                      style: TextStyle(
                        fontSize: 18,
                        color: whiteTextColor,
                      ),
                    ),
                  ),
                ),
                // ElevatedButton(
                //     onPressed: () {},
                //     style: ElevatedButton.styleFrom(
                //       shape: const RoundedRectangleBorder(),
                //       fixedSize: const Size(150, 40),
                //     ),
                //     child: const Text("Student")),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'StudentHub is university market place to connect high-skilled student and company on a real-world project',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 200,
                  height: 45,
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    border: Border.all(color: lightgrayColor, width: 2.0),
                    color: mainColor,
                    boxShadow: const [
                      BoxShadow(
                        color: lightgrayColor,
                        offset: Offset(0, 0),
                        blurRadius: 1.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signin');
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(mainColor),
                    ),
                    child: const Text(
                      'Start StudentHub',
                      style: TextStyle(
                        fontSize: 18,
                        color: whiteTextColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ))),
    );
  }
}
