import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../components/appbar_ps1.dart';
import 'package:studenthub/models/company_model.dart';
import 'package:http/http.dart' as http;

class ProjectPostStep4Page extends StatelessWidget{
  final Map<String, dynamic> box;
  final String uriBase = 'http://localhost:4400';
  const ProjectPostStep4Page({super.key, required this.box});

  Future<void> postProject() async{
    // final prefs = await SharedPreferences.getInstance();
    ProjectPost modelDataProject = ProjectPost('1', 1, box['title'], box['description'], 1);
    final modelDataProjectJson = modelDataProject.toJson();
    try{
      final response = await http.post(
        Uri.parse('$uriBase/api/project'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(modelDataProjectJson),
      );
      if(response.statusCode == 201){
        print('okeeeee');
      }
    }
    catch(e){
      print(e);
    }
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('4/4       Next, provide project description', style: TextStyle(fontWeight: FontWeight.bold),),
                        const SizedBox(height: 30,),
                        Text(box['title'], style: const TextStyle(fontWeight: FontWeight.bold),),
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
                                Padding(padding: const EdgeInsets.only(left: 30), child: Text('• ${box['projectScore']} months'),),
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
                                Text('• ${box['qualityStudent']} students'),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: (){
                        postProject();
                      },
                      style: ElevatedButton.styleFrom(shape:const RoundedRectangleBorder()),
                      child: const Text('Post job'),
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