import 'package:flutter/material.dart';
import '../../../components/appbar_ps1.dart';
import 'project_post_step3_screen.dart';


class ProjectPostStep2Page extends StatefulWidget{
  final Map<String, dynamic> box;

  const ProjectPostStep2Page({super.key, required this.box});

  @override
  State<ProjectPostStep2Page> createState()=> ProjectPostStep2PageState();
}
class ProjectPostStep2PageState extends State<ProjectPostStep2Page>{
  bool _erro = false;
  final TextEditingController _quantityStudent = TextEditingController();
  int _isChecked = 0;

  void validateTextfield(String value){
    setState(() {
      if(value.isEmpty) {
        _erro = true;
      } else if(!(num.tryParse(value) != null)){
        _erro = true;
      }
      else{
        _erro = false;
      }
    });
  }
  @override
  void dispose(){
    _quantityStudent.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    return SafeArea(
        child: Scaffold(
          appBar: const AppBar_PostPS1(),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 30,),
                  const Text('2/4 \t\t Next, estimate the scope of your job', style: TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(height: 10,),
                  const Text('Consider the size of your project and the timeline'),
                  const SizedBox(height: 30,),
                  const Text('How long will your project take?'),
                  const SizedBox(height: 20,),
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
                  const SizedBox(height: 20,),
                  const Text('How many students do you want for this project?'),
                  const SizedBox(height: 20,),
                  TextField(
                    controller: _quantityStudent,
                    onChanged: validateTextfield,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'number of students',
                      hintStyle: TextStyle(fontSize: 15),
                      isDense: true,
                      contentPadding: EdgeInsets.all(5),
                      errorText: _erro ? 'Please enter number of students' : null,
                    ),
                  ),
                  const SizedBox(height: 40,),
                  Align(
                    alignment: Alignment.centerRight,
                    child:ElevatedButton(
                      onPressed: (){
                        if(!_erro){
                          print(_isChecked.runtimeType);
                          widget.box.putIfAbsent('projectScore', () => _isChecked);
                          widget.box.putIfAbsent('quantityStudent', () => int.parse(_quantityStudent.text));
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => ProjectPostStep3Page(box: widget.box,)),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()),
                      child: const Text('Next: Description'),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}

