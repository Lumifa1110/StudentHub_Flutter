import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';
import 'package:studenthub/utils/colors.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const AuthAppBar(canBack: false),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              // Design for notification card 1 (predict type: personal)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: FaIcon(
                        FontAwesomeIcons.universalAccess,
                        size: 36,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'You have submitted to join project \"Javis - AI Copilot\"',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: blackTextColor),
                            overflow: TextOverflow.clip,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '6/6/2024',
                            style:
                                TextStyle(fontSize: 16, color: lightgrayColor),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                height: 1.0,
                thickness: 3.0,
                color: blackTextColor,
                indent: 20,
                endIndent: 20,
              ),
              // Design for notification card 2 (predict type: system, invited)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: FaIcon(
                        FontAwesomeIcons.gear,
                        size: 36,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'You have invited to interview for project \"Javis - AI Copilot\" at 14:00 March 20, Thurday',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: blackTextColor),
                            overflow: TextOverflow.clip,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            '6/6/2024',
                            style:
                                TextStyle(fontSize: 16, color: lightgrayColor),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: 180,
                            height: 40,
                            padding: const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: blackTextColor, width: 2.0),
                              color: whiteTextColor,
                              boxShadow: const [
                                BoxShadow(
                                  color: blackTextColor,
                                  offset: Offset(2, 3),
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                ),
                              ),
                              child: const Text(
                                'Join',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: blackTextColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                height: 1.0,
                thickness: 3.0,
                color: blackTextColor,
                indent: 20,
                endIndent: 20,
              ),
              // Design for notification card 3 (predict type: system, offer)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: FaIcon(
                        FontAwesomeIcons.cog,
                        size: 36,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'You have invited to interview for project \"Javis - AI Copilot\" at 14:00 March 20, Thurday',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: blackTextColor),
                            overflow: TextOverflow.clip,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            '6/6/2024',
                            style:
                                TextStyle(fontSize: 16, color: lightgrayColor),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            width: 180,
                            height: 40,
                            padding: const EdgeInsets.all(0),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: blackTextColor, width: 2.0),
                              color: whiteTextColor,
                              boxShadow: const [
                                BoxShadow(
                                  color: blackTextColor,
                                  offset: Offset(2, 3),
                                ),
                              ],
                            ),
                            child: TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                shape:
                                    MaterialStateProperty.all<OutlinedBorder>(
                                  const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero),
                                ),
                              ),
                              child: const Text(
                                'View offer',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: blackTextColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1.0,
                      thickness: 3.0,
                      color: blackTextColor,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 1.0,
                thickness: 3.0,
                color: blackTextColor,
                indent: 20,
                endIndent: 20,
              ),
              // Design for notification card 4 (predict type: personal-message)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: FaIcon(
                        FontAwesomeIcons.universalAccess,
                        size: 36,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alex Jor',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: blackTextColor),
                            overflow: TextOverflow.clip,
                          ),
                          Text(
                            'How are you today ?',
                            style:
                                TextStyle(fontSize: 16, color: blackTextColor),
                            overflow: TextOverflow.clip,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            '6/6/2024',
                            style:
                                TextStyle(fontSize: 16, color: lightgrayColor),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 1.0,
                      thickness: 3.0,
                      color: blackTextColor,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const CustomBottomNavBar(initialIndex: 3),
      ),
    );
  }
}
