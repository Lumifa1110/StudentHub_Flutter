import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../components/appbar_ps1.dart';
import 'package:studenthub/models/company_model.dart';
import 'package:http/http.dart' as http;

class CompanyDashboardScreen extends StatefulWidget{
  const CompanyDashboardScreen({super.key});

  @override
  State<CompanyDashboardScreen> createState()=> CompanyDashboardScreenState();
}

class CompanyDashboardScreenState extends State<CompanyDashboardScreen> {

  late List<Project> listProjectGet = [];
  late SharedPreferences _prefs;


  //Get projects data on /api/project
  Future<void> _loadProject() async{
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    try{
      final responseJson = await http.get(Uri.parse('http://localhost:4400/api/project'),
        headers: {'Authorization' : 'Bearer $token'},
      );
      final responseDecode = jsonDecode(responseJson.body)["result"];
      for(int i = 0; i < responseDecode.length; i++){
        listProjectGet.add(Project(title: responseDecode[i]['title'], implementationTime: "Null", qualityStudent: 0, describe: responseDecode[i]['description'], createdAt: responseDecode[i]['createdAt']));
      }
    }
    catch(e){
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadProject(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return SafeArea(
            child: Scaffold(
                appBar: const AppBar_PostPS1(),
                body:Padding(
                  padding: const EdgeInsets.all(20),
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(width: 5,),
                            const Text('Your projects', style: TextStyle(fontWeight: FontWeight.bold),),
                            const SizedBox(width: 30,),
                            ElevatedButton(onPressed: (){
                              Navigator.pushReplacementNamed(context, '/company/project/step1');
                            },
                              style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()),
                              child: const Text('Post a jobs'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),

                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(width: 2),
                              borderRadius: BorderRadius.circular(12)
                          ),
                          child: TabBar(
                              indicator: BoxDecoration(
                                color: Colors.greenAccent,
                                borderRadius: BorderRadius.circular(11),
                                border: Border.all(width: 1),
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              tabs:  const <Widget> [
                                Tab(text: 'All project',),
                                Tab(text: 'Archieved',)
                              ]
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: listProjectGet.length,
                                  itemBuilder: (BuildContext context, int index){
                                    final project = listProjectGet[index];
                                    return Column(
                                      children: [
                                        const SizedBox(height: 20,),
                                        OptionProjectCompany(
                                          onTap: (){
                                          },
                                          project: project,
                                        ),
                                        if(index < listProjectGet.length - 1)
                                          const Divider(
                                            thickness: 2,
                                            indent: 10,
                                            endIndent: 10,
                                            color: Colors.black,
                                          ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              const Center(child: Text('Tab 3 content')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
            ),
          );
        }
      },
    );
  }
}

class OptionProjectCompany extends StatefulWidget{
  final VoidCallback onTap;
  final Project project;

  const OptionProjectCompany({super.key, required this.onTap, required this.project});
  //function
  int f_dayCreatedAgo(String createdAt){
    DateTime timeParse = DateTime.parse(createdAt);
    DateTime now = DateTime.now();
    Duration difference = now.difference(timeParse);

    return difference.inDays;
  }
  @override
  State<OptionProjectCompany> createState()=>
      OptionProjectCompanyState();

}

class OptionProjectCompanyState extends State<OptionProjectCompany>{
  @override
  Widget build(BuildContext context){
    return InkWell(
      onTap: widget.onTap,
      child:  Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  const SizedBox(height: 15,),
                  Text(widget.project.title, style: const TextStyle(color: Colors.green),),
                  Text('Created ${widget.f_dayCreatedAgo(widget.project.createdAt)} days ago',style: const TextStyle(color: Colors.grey),),
                  const SizedBox(height: 10,),
                  const Text('Students are looking for'),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text('• Clear expectation about your project or deliverables'),),
                  const SizedBox(height: 20,),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('0'),
                          Text('Proposals')
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('8'),
                          Text('Messages')
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('2'),
                          Text('Hired')
                        ],
                      ),
                    ],
                  ),
                ]
            ),
          ),
          ElevatedButton(
            onPressed: (){
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 350,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16.0),
                                minimumSize: const Size(double.infinity, 0),
                                shape: const RoundedRectangleBorder()
                            ),
                            child: const Text('View Proposals'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16.0),
                                minimumSize: const Size(double.infinity, 0),
                                shape:  const RoundedRectangleBorder()

                            ),
                            child: const Text('View messages'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16.0),
                                minimumSize: const Size(double.infinity, 0),
                                shape: const RoundedRectangleBorder()
                            ),
                            child: const Text('View hired'),
                          ),
                          const Divider(
                            thickness: 2,
                            indent: 10,
                            endIndent: 10,
                            color: Colors.black,
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16.0),
                                minimumSize: const Size(double.infinity, 0),
                                shape: const RoundedRectangleBorder()
                            ),
                            child: const Text('View job posting'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16.0),
                                minimumSize: const Size(double.infinity, 0),
                                shape: const RoundedRectangleBorder()
                            ),
                            child: const Text('Edit posting'),
                          ),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(16.0),
                                minimumSize: const Size(double.infinity, 0),
                                shape: const RoundedRectangleBorder()
                            ),
                            child: const Text('Remove posting'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }, style: ElevatedButton.styleFrom(shape: const CircleBorder()),
            child: const Text('...'),
          ),
        ],
      ),
    );
  }
}

