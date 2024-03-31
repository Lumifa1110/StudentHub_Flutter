import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import '../components/appbar_ps1.dart';
import '../components/appbar_dashboard.dart';


class Dashboard_page extends StatelessWidget {
  const Dashboard_page({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppbarDashboard(),
          body:Padding(
            padding: EdgeInsets.all(20),
            child: DefaultTabController(
              length: 3,
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
                          Tab(
                            child: Container(
                              height: 50,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text('All project'),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12)
                              ),
                            ),
                          ),
                          Tab(text: 'working',),
                          Tab(text: 'Archieved',)
                        ]
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Container(
                          child: Column(
                            children: [
                              SizedBox(height: 30,),
                              Text('Welcom, Hai!'),
                              Text('You have no jobs!'),
                            ],
                          ),
                        ),
                        Center(child: Text('Tab 2 content')),
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
