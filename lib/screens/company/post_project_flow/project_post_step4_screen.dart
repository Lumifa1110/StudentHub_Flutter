import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../components/appbar_ps1.dart';
import 'package:studenthub/models/company_model.dart';
import 'package:http/http.dart' as http;
import 'package:studenthub/business/company_business.dart';
import 'package:studenthub/config/config.dart';

class ProjectPostStep4Page extends StatelessWidget{
  final Map<String, dynamic> box;
  const ProjectPostStep4Page({super.key, required this.box});

  Future<void> postProject(BuildContext context) async{

    SharedPreferences _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');

    ProjectPost modelDataProject = ProjectPost('1', box['projectScore'], box['title'], box['quantityStudent'], box['description'], 1);
    final modelDataProjectJson = modelDataProject.toJson();
    try{
      final response = await http.post(
        Uri.parse('$uriBase/api/project'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(modelDataProjectJson),
      );
      if(response.statusCode == 201){
        Navigator.pushReplacementNamed(context, '/company/dashboard');
      }
      else
        print(response.body);
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
                        const Text('4/4       Project details', style: TextStyle(fontWeight: FontWeight.bold),),
                        const SizedBox(height: 30,),
                        Text('Title of the job: ${box['title']}', style: const TextStyle(fontWeight: FontWeight.bold),),
                        const SizedBox(height: 10,),
                        const Divider(
                          thickness: 2,
                          indent: 10,
                          endIndent: 10,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 10,),
                        const Text('Describe your project:', style: TextStyle(fontWeight: FontWeight.bold),),
                        Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(box['description'], overflow: TextOverflow.ellipsis, maxLines: 10, softWrap: true,),
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
                            Padding(
                              padding: const EdgeInsets.only(left: 30),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Project scope',style: TextStyle(fontWeight: FontWeight.bold),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text('• ${convertProjectScoreFlagToTime(box['projectScore'])} months'),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Row(
                          children: [
                            const Icon(CupertinoIcons.person_2, size: 40,),
                            Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text('Student required',style: TextStyle(fontWeight: FontWeight.bold),),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text('• ${box['quantityStudent']} students'),
                                  ),
                                ],
                              ),
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
                        postProject(context);
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