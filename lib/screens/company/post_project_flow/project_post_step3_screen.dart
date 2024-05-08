import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/utils/font.dart';
import 'project_post_step4_screen.dart';

class ProjectPostStep3Page extends StatefulWidget {
  final Map<String, dynamic> box;
  const ProjectPostStep3Page({super.key, required this.box});
  @override
  State<ProjectPostStep3Page> createState() => ProjectPostStep3PageState();
}

class ProjectPostStep3PageState extends State<ProjectPostStep3Page> {
  bool _erro = false;
  final TextEditingController _describe = TextEditingController();

  void _validateDicribe(String value) {
    setState(() {
      _erro = value.isEmpty;
    });
  }

  @override
  void initState() {
    super.initState();
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
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '3/4 \t \t Next, provide project description',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppFonts.h2FontSize),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text('Students are looking for'),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text('• Clear expectation about your project or deliverables'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text('• The skills required for your project'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text('• Detail about your project'),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Describe your project',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                maxLines: 8,
                controller: _describe,
                onChanged: _validateDicribe,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    isDense: true,
                    errorText: _erro ? 'Please enter description' : null),
              ),
              const SizedBox(
                height: 10,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (!_erro) {
                      String description = _describe.text.isEmpty
                          ? 'Students are looking for\n\t\t-Clear expectation about your project or deliverables\n\t\t-The skills required for your project\n\t\t-Detail about your project'
                          : _describe.text;
                      widget.box.putIfAbsent('description', () => description);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectPostStep4Page(
                            box: widget.box,
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()),
                  child: const Text('Review your post'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
