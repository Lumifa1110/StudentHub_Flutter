import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/bottomsheet_schedule.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/utils/colors.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    String title = '';
    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();
    return SafeArea(
      child: Scaffold(
        appBar: AuthAppBar(canBack: false),
        body: Column(
          children: [
            Text('This is fake Message'),
            Center(
              child: ElevatedButton(
                child: const Text('showModalBottomSheet'),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    barrierColor: Colors.black.withAlpha(1),
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(0)),
                    ),
                    builder: (BuildContext context) {
                      return Container(
                        decoration: BoxDecoration(
                          color: lightestgrayColor,
                          boxShadow: [
                            BoxShadow(
                              color: blackTextColor.withOpacity(0.5),
                              spreadRadius: 6,
                              blurRadius: 9,
                              offset: const Offset(
                                  0, 1), // changes position of shadow
                            ),
                          ],
                        ),
                        child: SizedBox(
                            height: MediaQuery.of(context).size.height * 5 / 9,
                            child: BottomSheetSchedule(
                                title: title,
                                startDate: startDate,
                                endDate: endDate)),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(
          initialIndex: 2,
        ),
      ),
    );
  }
}
