import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../business/company_business.dart';

class StudentDashboardDetail extends StatelessWidget {
  final dynamic detailProject;
  final String nameStudent;

  const StudentDashboardDetail({super.key, this.detailProject, required this.nameStudent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(
        canBack: true,
        isShowIcon: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Project',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                    // height: 400,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10), border: Border.all()),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Expanded(
                                  child:
                                      Text('Title', style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(child: Text('${detailProject['project']['title']}')),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Expanded(
                                child: Text('Number of students',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              Expanded(
                                child: Text('${detailProject['project']['numberOfStudents']}'),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              const Expanded(
                                  child: Text('Project Scope',
                                      style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(
                                  child: Text(convertProjectScoreFlagToTime(
                                      detailProject['project']['numberOfStudents']))),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(
                                  child: Text('Description',
                                      style: TextStyle(fontWeight: FontWeight.bold))),
                              Expanded(
                                child: SizedBox(
                                  height: 100,
                                  child: SingleChildScrollView(
                                    child: Text(
                                      '${detailProject['project']['description']}',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'My proposal',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
                decoration:
                    BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Name',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(child: Text(nameStudent)),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(
                            child: Text(
                              'Cover Letter',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            '${detailProject['coverLetter']}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text('State of proposal',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          MytimeLineTile(
                              isFirst: true,
                              isLast: false,
                              isPast: detailProject['statusFlag'] >= 0 ? true : false,
                              strState: 'Waiting'),
                          MytimeLineTile(
                            isFirst: false,
                            isLast: false,
                            isPast: detailProject['statusFlag'] >= 1 ? true : false,
                            strState: 'Active',
                          ),
                          MytimeLineTile(
                            isFirst: false,
                            isLast: false,
                            isPast: detailProject['statusFlag'] >= 2 ? true : false,
                            strState: 'Offer',
                          ),
                          MytimeLineTile(
                            isFirst: false,
                            isLast: true,
                            isPast: detailProject['statusFlag'] >= 3 ? true : false,
                            strState: 'Hired',
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          ],
        ),
      ),
      // bottomNavigationBar:const CustomBottomNavBar(initialIndex: 1),
    );
  }
}

class MytimeLineTile extends StatelessWidget {
  final bool isFirst;
  final bool isLast;
  final bool isPast;
  final String strState;

  const MytimeLineTile(
      {super.key,
      required this.isFirst,
      required this.isLast,
      required this.isPast,
      required this.strState});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 150,
      child: TimelineTile(
        axis: TimelineAxis.horizontal,
        isFirst: isFirst,
        isLast: isLast,
        alignment: TimelineAlign.center,
        beforeLineStyle: LineStyle(color: isPast ? Colors.blue : Colors.blue.shade100),
        indicatorStyle: IndicatorStyle(
            height: 30,
            color: isPast ? Colors.blue : Colors.blue.shade100,
            iconStyle: IconStyle(iconData: Icons.done, color: Colors.white)),
        endChild: EventCart(
          strState: strState,
          isPast: isPast,
        ),
      ),
    );
  }
}

class EventCart extends StatelessWidget {
  final String strState;
  final bool isPast;

  const EventCart({super.key, required this.strState, required this.isPast});

  @override
  Widget build(BuildContext context) {
    return !isPast
        ? const SizedBox()
        : Container(
            margin: const EdgeInsets.all(10),
            width: 60,
            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5)),
            child: Center(
              child: Text(strState),
            ));
  }
}
