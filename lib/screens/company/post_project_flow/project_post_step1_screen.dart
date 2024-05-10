import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/utils/font.dart';
import 'project_post_step2_screen.dart';

class ProjectPostStep1Page extends StatefulWidget {
  const ProjectPostStep1Page({super.key});

  @override
  State<ProjectPostStep1Page> createState() => ProjectPostStep1PageState();
}

class ProjectPostStep1PageState extends State<ProjectPostStep1Page> {
  final TextEditingController _titleProject = TextEditingController();
  bool _erro = false;
  // @override
  // void dispose() {
  //   _titleProject.dispose();
  //   super.dispose();
  // }

  void _fValiteDate(String value) {
    setState(() {
      _erro = value.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(canBack: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                '1/4 \t \t Let\'s start with a strong tittle',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppFonts.h2FontSize),
              ),
              const SizedBox(
                height: 30,
              ),
              const Center(
                child: Text(
                  'This helps your post stand out to the right students. It\'s the first thing they\' see, so make it impressive!',
                  style: TextStyle(fontSize: AppFonts.h3FontSize),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: TextField(
                  controller: _titleProject,
                  onChanged: _fValiteDate,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintStyle: const TextStyle(fontSize: AppFonts.h3FontSize),
                    isDense: true,
                    contentPadding: const EdgeInsets.all(5),
                    errorText: _erro ? 'Please enter a title' : null,
                    hintText: 'write a title for jour post',
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Text(
                'Example titles',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppFonts.h3FontSize),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    '• Build responsive WordPress site with booking/payment functionality',
                    style: TextStyle(fontSize: AppFonts.h3FontSize),
                  )),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  '• Facebook ad specialist need for product launch',
                  style: TextStyle(fontSize: AppFonts.h3FontSize),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_titleProject.text.trim().isEmpty) {
                        _fValiteDate(_titleProject.text.trim());
                      }
                      if (!_erro) {
                        final Map<String, dynamic> box = {"title": _titleProject.text};
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProjectPostStep2Page(
                              box: box,
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()),
                    child: const Text("Next: Score"),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
