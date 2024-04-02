import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import '../../../components/appbar_ps1.dart';
class ProjectPostStep4Page extends StatelessWidget{
  late String _titleProject;
  late int _numberStudent;
  late String _decribe;
  late String _projectScore;
  ProjectPostStep4Page(this._titleProject, this._numberStudent, this._projectScore,  this._decribe);
  @override
  Widget build(BuildContext context){

    return SafeArea(
        child: Scaffold(
          appBar: AppBar_PostPS1(),
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('4/4       Next, provide project description', style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 30,),
                        Text('$_titleProject', style: TextStyle(fontWeight: FontWeight.bold),),
                        SizedBox(height: 10,),
                        Divider(
                          thickness: 2,
                          indent: 10,
                          endIndent: 10,
                          color: Colors.black,
                        ),
                        SizedBox(height: 10,),
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
                        SizedBox(height: 10,),
                        Divider(
                          thickness: 2,
                          indent: 10,
                          endIndent: 10,
                          color: Colors.black,
                        ),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Icon(CupertinoIcons.clock, size: 40,),
                            Column(
                              children: [
                                Text('Project scope'),
                                Padding(padding: EdgeInsets.only(left: 30), child: Text('• $_projectScore'),),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 20,),
                        Row(
                          children: [
                            Icon(CupertinoIcons.person_2, size: 40,),
                            SizedBox(width: 20,),
                            Column(
                              children: [
                                Text('Student required'),
                                Text('• $_numberStudent students'),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(onPressed: (){}, child: const Text('Post job'), style: ElevatedButton.styleFrom(shape:RoundedRectangleBorder()),),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}