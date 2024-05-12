import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/utils/font.dart';
import 'project_post_step3_screen.dart';

class ProjectPostStep2Page extends StatefulWidget {
  final Map<String, dynamic> box;

  const ProjectPostStep2Page({super.key, required this.box});

  @override
  State<ProjectPostStep2Page> createState() => ProjectPostStep2PageState();
}

class ProjectPostStep2PageState extends State<ProjectPostStep2Page> {
  bool _erro = false;
  final TextEditingController _quantityStudent = TextEditingController();
  int _isChecked = 0;

  void validateTextfield(String value) {
    setState(() {
      if (value.isEmpty) {
        _erro = true;
      } else if (!(num.tryParse(value) != null)) {
        _erro = true;
      } else if (num.tryParse(value) == 0) {
        _erro = true;
      } else {
        _erro = false;
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _quantityStudent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(canBack: true),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  '2/4 \t\t Next, estimate the scope of your job',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppFonts.h2FontSize),
                ),
                const Text(
                  'Consider the size of your project and the timeline',
                  style: TextStyle(fontSize: AppFonts.h3FontSize),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'How long will your project take?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppFonts.h3FontSize),
                ),
                Container(
                  child:Column(
                    children: [
                      ListTile(
                        title: const Text('Less Than 1 Month', style: TextStyle(fontSize: 14)),
                        leading: Radio(
                          value: 0, // Set value to 3
                          groupValue: _isChecked,
                          onChanged: (value) {
                            setState(() {
                              _isChecked = value as int;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('1 to 3 months', style: TextStyle(fontSize: 14)),
                        leading: Radio(
                          value: 1, // Set value to 6
                          groupValue: _isChecked,
                          onChanged: (value) {
                            setState(() {
                              _isChecked = value as int;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('3 to 6 months', style: TextStyle(fontSize: 14)),
                        leading: Radio(
                          value: 2, // Set value to 6
                          groupValue: _isChecked,
                          onChanged: (value) {
                            setState(() {
                              _isChecked = value as int;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('More than 6 months', style: TextStyle(fontSize: 14)),
                        leading: Radio(
                          value: 3, // Set value to 6
                          groupValue: _isChecked,
                          onChanged: (value) {
                            setState(() {
                              _isChecked = value as int;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'How many students do you want for this project? (*)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: AppFonts.h3FontSize),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _quantityStudent,
                  onChanged: validateTextfield,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'number of students',
                    hintStyle: const TextStyle(fontSize: 15),
                    isDense: true,
                    contentPadding: const EdgeInsets.all(5),
                    errorText: _erro ? 'Please enter number of students' : null,
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop(true);
                        },
                        style: ElevatedButton.styleFrom(shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                        child: const Text('Back'),
                      ),
                      SizedBox(width: 5,),
                      ElevatedButton(
                        onPressed: () {
                          if (_quantityStudent.text.isEmpty) {
                            validateTextfield(_quantityStudent.text.trim());
                          } else {
                            if (!_erro) {
                              // Check if the quantity text is not empty
                              if (_quantityStudent.text.isNotEmpty) {
                                try {
                                  int quantity = int.parse(_quantityStudent.text);
                                  if(widget.box.containsKey('quantityStudent')){
                                    widget.box['quantityStudent'] = quantity;
                                  }
                                  else{
                                    widget.box.putIfAbsent('quantityStudent', () => quantity);
                                  }
                                } catch (e) {
                                  // Handle the case where parsing fails
                                  print('Failed to parse quantity: $e');
                                  setState(() {
                                    _erro = true;
                                  });
                                  return; // Return to prevent navigation if parsing fails
                                }
                              }
                              if(widget.box.containsKey('projectScore')){
                                widget.box['projectScore'] = _isChecked;
                              }
                              else{
                                widget.box.putIfAbsent('projectScore', () => _isChecked);
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProjectPostStep3Page(
                                    box: widget.box,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                        child: const Text('Next: Description'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
