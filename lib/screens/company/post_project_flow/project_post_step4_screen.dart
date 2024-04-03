import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../components/appbar_ps1.dart';
class ProjectPostStep4Page extends StatelessWidget{
  late final String _titleProject;
  late final int _numberStudent;
  late final String _projectScore;
  ProjectPostStep4Page(this._titleProject, this._numberStudent, this._projectScore, {super.key});
  @override
  Widget build(BuildContext context){

    return SafeArea(
        child: Scaffold(
          appBar: const AppBar_PostPS1(),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('4/4       Next, provide project description', style: TextStyle(fontWeight: FontWeight.bold),),
                      const SizedBox(height: 30,),
                      Text(_titleProject, style: const TextStyle(fontWeight: FontWeight.bold),),
                      const SizedBox(height: 10,),
                      const Divider(
                        thickness: 2,
                        indent: 10,
                        endIndent: 10,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 10,),
                      const Text('Students are looking for'),
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('• Clear expectation about your project or deliverables'),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('• The skills required for your project'),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text('• Detail about your project'),
                      ),
                      const SizedBox(height: 10,),
                      const Divider(
                        thickness: 2,
                        indent: 10,
                        endIndent: 10,
                        color: Colors.black,
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        children: [
                          const Icon(CupertinoIcons.clock, size: 40,),
                          Column(
                            children: [
                              const Text('Project scope'),
                              Padding(padding: const EdgeInsets.only(left: 30), child: Text('• $_projectScore'),),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 20,),
                      Row(
                        children: [
                          const Icon(CupertinoIcons.person_2, size: 40,),
                          const SizedBox(width: 20,),
                          Column(
                            children: [
                              const Text('Student required'),
                              Text('• $_numberStudent students'),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(shape:const RoundedRectangleBorder()), child: const Text('Post job'),),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}