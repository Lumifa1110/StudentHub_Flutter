import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import '../../components/appbar_ps1.dart';


class Dashboard_ViewListProject_page extends StatelessWidget {
  const Dashboard_ViewListProject_page({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar_PostPS1(),
          body:Padding(
            padding: EdgeInsets.all(20),
            child: DefaultTabController(
              length: 2,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 5,),
                      Text('Your projects', style: TextStyle(fontWeight: FontWeight.bold),),
                      SizedBox(width: 30,),
                      ElevatedButton(onPressed: (){}, child: Text('Post a jobs'),style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder()),)
                    ],
                  ),
                  SizedBox(height: 10,),

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
                        tabs:  <Widget> [
                          Tab(text: 'All project',),
                          Tab(text: 'Archieved',)
                        ]
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Center(
                          child: Column(
                            children:[
                              SizedBox(height: 20,),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:[
                                            SizedBox(height: 15,),
                                            Text('Senior frontend developer (Fintech)', style: TextStyle(color: Colors.green),),
                                            Text('Created 3 days ago',style: TextStyle(color: Colors.grey),),
                                            SizedBox(height: 10,),
                                            Text('Students are looking for'),
                                            Padding(
                                              padding: EdgeInsets.only(left: 20),
                                              child: Text('• Clear expectation about your project or deliverables'),),
                                            SizedBox(height: 20,),
                                            Row(
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
                                            return Container(
                                              height: 350,
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  // mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    ElevatedButton(
                                                      child: const Text('View Proposals'),
                                                      onPressed: () => Navigator.pop(context),
                                                      style: ElevatedButton.styleFrom(
                                                        padding: EdgeInsets.all(16.0),
                                                        minimumSize: Size(double.infinity, 0),
                                                        shape: RoundedRectangleBorder()
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      child: const Text('View messages'),
                                                      onPressed: () => Navigator.pop(context),
                                                      style: ElevatedButton.styleFrom(
                                                        padding: EdgeInsets.all(16.0),
                                                        minimumSize: Size(double.infinity, 0),
                                                        shape:  RoundedRectangleBorder()

                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      child: const Text('View hired'),
                                                      onPressed: () => Navigator.pop(context),
                                                      style: ElevatedButton.styleFrom(
                                                        padding: EdgeInsets.all(16.0),
                                                        minimumSize: Size(double.infinity, 0),
                                                        shape: RoundedRectangleBorder()
                                                      ),
                                                    ),
                                                    Divider(
                                                      thickness: 2,
                                                      indent: 10,
                                                      endIndent: 10,
                                                      color: Colors.black,
                                                    ),
                                                    ElevatedButton(
                                                      child: const Text('View job posting'),
                                                      onPressed: () => Navigator.pop(context),
                                                      style: ElevatedButton.styleFrom(
                                                        padding: EdgeInsets.all(16.0),
                                                        minimumSize: Size(double.infinity, 0),
                                                        shape: RoundedRectangleBorder()
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      child: const Text('Edit posting'),
                                                      onPressed: () => Navigator.pop(context),
                                                      style: ElevatedButton.styleFrom(
                                                        padding: EdgeInsets.all(16.0),
                                                        minimumSize: Size(double.infinity, 0),
                                                        shape: RoundedRectangleBorder()
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      child: const Text('Remove posting'),
                                                      onPressed: () => Navigator.pop(context),
                                                      style: ElevatedButton.styleFrom(
                                                        padding: EdgeInsets.all(16.0),
                                                        minimumSize: Size(double.infinity, 0),
                                                        shape: RoundedRectangleBorder()
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: const Text('...'), style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20,),
                              Divider(
                                thickness: 2,
                                endIndent: 10,
                                color: Colors.black,
                              ),
                              Container(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:[
                                            SizedBox(height: 15,),
                                            Text('Senior frontend developer (Fintech)', style: TextStyle(color: Colors.green),),
                                            Text('Created 5 days ago', style: TextStyle(color: Colors.grey)),
                                            SizedBox(height: 10,),
                                            Text('Students are looking for'),
                                            Padding(
                                              padding: EdgeInsets.only(left: 20),
                                              child: Text('• Clear expectation about your project or deliverables'),),
                                            SizedBox(height: 20,),
                                            Row(
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
                                            return Container(
                                              height: 350,
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  // mainAxisAlignment: MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    ElevatedButton(
                                                      child: const Text('View Proposals'),
                                                      onPressed: () => Navigator.pop(context),
                                                      style: ElevatedButton.styleFrom(
                                                        padding: EdgeInsets.all(16.0),
                                                        minimumSize: Size(double.infinity, 0),
                                                        shape: RoundedRectangleBorder()
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      child: const Text('View messages'),
                                                      onPressed: () => Navigator.pop(context),
                                                      style: ElevatedButton.styleFrom(
                                                        padding: EdgeInsets.all(16.0),
                                                        minimumSize: Size(double.infinity, 0),
                                                        shape: RoundedRectangleBorder()
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      child: const Text('View hired'),
                                                      onPressed: () => Navigator.pop(context),
                                                      style: ElevatedButton.styleFrom(
                                                        padding: EdgeInsets.all(16.0),
                                                        minimumSize: Size(double.infinity, 0),
                                                        shape: RoundedRectangleBorder()
                                                      ),
                                                    ),
                                                    Divider(
                                                      thickness: 2,
                                                      indent: 10,
                                                      endIndent: 10,
                                                      color: Colors.black,
                                                    ),
                                                    ElevatedButton(
                                                      child: const Text('View job posting'),
                                                      onPressed: () => Navigator.pop(context),
                                                      style: ElevatedButton.styleFrom(
                                                        padding: EdgeInsets.all(16.0),
                                                        minimumSize: Size(double.infinity, 0),
                                                        shape: RoundedRectangleBorder()
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      child: const Text('Edit posting'),
                                                      onPressed: () => Navigator.pop(context),
                                                      style: ElevatedButton.styleFrom(
                                                        padding: EdgeInsets.all(16.0),
                                                        minimumSize: Size(double.infinity, 0),
                                                        shape: RoundedRectangleBorder()
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      child: const Text('Remove posting'),
                                                      onPressed: () => Navigator.pop(context),
                                                      style: ElevatedButton.styleFrom(
                                                        padding: EdgeInsets.all(16.0),
                                                        minimumSize: Size(double.infinity, 0),
                                                        shape: RoundedRectangleBorder()
                                                      ),

                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: const Text('...'), style: ElevatedButton.styleFrom(shape: const CircleBorder()),
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          ),
                        ),
                        Center(child: Text('Tab 3 content')),
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
}
