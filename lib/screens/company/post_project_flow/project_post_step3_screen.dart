import 'package:flutter/material.dart';
import '../../../components/appbar_ps1.dart';
import 'project_post_step4_screen.dart';

class ProjectPostStep3Page extends StatefulWidget{
  final Map<String, dynamic> box;
  const ProjectPostStep3Page({super.key, required this.box});
  @override
  State<ProjectPostStep3Page> createState()=> ProjectPostStep3PageState();
}
class ProjectPostStep3PageState extends State<ProjectPostStep3Page>{
  bool _erro = false;
  final TextEditingController _describe = TextEditingController();

  void _validateDicribe(String value){
    setState(() {
      _erro = value.isEmpty;
    });
  }
  @override
  void dispose(){
    _describe.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context){
    return SafeArea(
        child: Scaffold(
          appBar: const AppBar_PostPS1(),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 90),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('3/4       Next, provide project description', style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(height: 30,),
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
                ),
                const SizedBox(height: 20,),
                const Text('Describe your project', style: TextStyle(fontWeight: FontWeight.bold),),
                const SizedBox(height: 10,),
                TextField(
                  maxLines: 8,
                  controller: _describe,
                  onChanged: _validateDicribe,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                    errorText: _erro ? 'Please enter description': null
                  ),
                ),
                const SizedBox(height: 10,),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: (){
                      if(!_erro){
                        widget.box.putIfAbsent('description', () => _describe.text);
                        // widget.box.forEach((key, value) {
                        //   print('$key: $value');
                        // });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => ProjectPostStep4Page(box: widget.box,)),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(shape:const RoundedRectangleBorder()),
                    child: const Text('Review your post'),),
                )
                
              ],
            ),
          ),
        )
    );
  }
}