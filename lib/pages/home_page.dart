import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        fixedSize: const Size(150, 40)),
                    child: const Text("Company")),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      fixedSize: const Size(150, 40),
                    ),
                    child: const Text("Student")),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'StudentHub is university market place to connect high-skilled student and company on a real-world project',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                )
              ],
            ),
          ))),
    );
  }
}
