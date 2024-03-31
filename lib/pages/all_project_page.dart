import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:studenthub/components/authappbar.dart';

import '../utils/mock_data.dart';

class AllProject extends StatelessWidget {
  const AllProject({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AuthAppBar(canBack: false),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: DefaultTabController(
            length: 3,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Your projects',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 2),
                      borderRadius: BorderRadius.circular(12)),
                  child: TabBar(
                      indicator: BoxDecoration(
                        color: Colors.greenAccent,
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(width: 1),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      tabs: const <Widget>[
                        Tab(
                          text: 'All project',
                        ),
                        Tab(
                          text: 'Working',
                        ),
                        Tab(
                          text: 'Archieved',
                        )
                      ]),
                ),
                Expanded(
                  child: TabBarView(children: [
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(border: Border.all()),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Active proposal(0)',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount:
                                            0, // Number of items in your list
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          final proposal = mockProposal[index];
                                          // itemBuilder builds each item in the list
                                          return OptionItem_AlProject_page(
                                              onTap: () {}, proposal: proposal);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                              flex: 6,
                              child: Container(
                                decoration: BoxDecoration(border: Border.all()),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Submitted proposal(${mockProposal.length})',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: mockProposal
                                              .length, // Number of items in your list
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final proposal =
                                                mockProposal[index];
                                            return OptionItem_AlProject_page(
                                                onTap: () {},
                                                proposal: proposal);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: ListView.builder(
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  final proposal = mockProposal[index];
                                  return OptionItem_Working_page(
                                      onTap: () {}, proposal: proposal);
                                }),
                          ),
                        ],
                      ),
                    ),
                    Center(child: Text('Tab 3 content')),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OptionItem_AlProject_page extends StatefulWidget {
  final VoidCallback onTap;
  final Proposal proposal;

  OptionItem_AlProject_page({
    super.key,
    required this.onTap,
    required this.proposal,
  });

  @override
  State<OptionItem_AlProject_page> createState() =>
      _OptionItem_AlProject_pageState();
}

class _OptionItem_AlProject_pageState extends State<OptionItem_AlProject_page> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.proposal.position,
              style: TextStyle(color: Colors.green),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Submitted ${widget.proposal.postingTime} days ago',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('Students are looking for'),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text('• ${widget.proposal.description[0]}'),
            ),
            const Divider(
              height: 60,
              endIndent: 10,
              thickness: 2,
            )
          ],
        ),
      ),
    );
  }
}

class OptionItem_Working_page extends StatefulWidget {
  final VoidCallback onTap;
  final Proposal proposal;

  OptionItem_Working_page({
    required this.onTap,
    required this.proposal,
  });

  @override
  State<OptionItem_Working_page> createState() =>
      _OptionItem_Working_pageState();
}

class _OptionItem_Working_pageState extends State<OptionItem_Working_page> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.proposal.position,
              style: TextStyle(color: Colors.green),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Time ${widget.proposal.executionTime}, ${widget.proposal.numberOfStudents} students',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Students are looking for'),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text('• ${widget.proposal.description[0]}'),
            ),
            Divider(
              height: 60,
              endIndent: 10,
              thickness: 2,
            )
          ],
        ),
      ),
    );
  }
}
