import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class ViewOfferScreen extends StatefulWidget {
  const ViewOfferScreen({Key? key}) : super(key: key);

  @override
  State<ViewOfferScreen> createState() => _ViewOfferScreenState();
}

class _ViewOfferScreenState extends State<ViewOfferScreen> {
  late bool isStudent = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: const AuthAppBar(canBack: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(),
              const Center(
                child: Text(
                  'OFFERING',
                  style: TextStyle(
                    fontSize: AppFonts.h1FontSize,
                    fontWeight: FontWeight.bold,
                    color: blackTextColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Party A:',
                style: TextStyle(
                  fontSize: AppFonts.h1_2FontSize,
                  fontWeight: FontWeight.bold,
                  color: blackTextColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Text(
                  'Lumifa Company is a very long company name case',
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1, // Adjust the number of lines to fit your layout
                  textAlign:
                      TextAlign.start, // Adjust the text alignment as needed
                  style: TextStyle(
                    fontSize: AppFonts.h2FontSize,
                    color: AppColor.tertiary,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Party B:',
                style: TextStyle(
                  fontSize: AppFonts.h1_2FontSize,
                  fontWeight: FontWeight.bold,
                  color: blackTextColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Talented Lumifa Student',
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: AppFonts.h2FontSize,
                            color: AppColor.tertiary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Applied on April 1',
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                          fontSize: AppFonts.h3FontSize,
                          color: lightgrayColor.withOpacity(0.5),
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Job Description: ',
                style: TextStyle(
                  fontSize: AppFonts.h1_2FontSize,
                  fontWeight: FontWeight.bold,
                  color: blackTextColor,
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                color: lightestgrayColor,
                child: const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                  style: TextStyle(fontSize: AppFonts.h3FontSize),
                ),
              ),
              const SizedBox(height: 5),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Position:',
                    style: TextStyle(
                      fontSize: AppFonts.h1_2FontSize,
                      fontWeight: FontWeight.bold,
                      color: blackTextColor,
                    ),
                  ),
                  Text(
                    'Fullstack Deveploper',
                    style: TextStyle(
                      fontSize: AppFonts.h2FontSize,
                      color: blackTextColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Text(
                'Terms and Conditions: ',
                style: TextStyle(
                  fontSize: AppFonts.h1_2FontSize,
                  fontWeight: FontWeight.bold,
                  color: blackTextColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                color: lightestgrayColor,
                child: const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                  style: TextStyle(fontSize: AppFonts.h3FontSize),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Benefits: ',
                style: TextStyle(
                  fontSize: AppFonts.h1_2FontSize,
                  fontWeight: FontWeight.bold,
                  color: blackTextColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                color: lightestgrayColor,
                child: const Text(
                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                  style: TextStyle(fontSize: AppFonts.h3FontSize),
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Payment: ',
                style: TextStyle(
                  fontSize: AppFonts.h1_2FontSize,
                  fontWeight: FontWeight.bold,
                  color: blackTextColor,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Start Date: ',
                style: TextStyle(
                  fontSize: AppFonts.h1_2FontSize,
                  fontWeight: FontWeight.bold,
                  color: blackTextColor,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'End Date (expected): ',
                style: TextStyle(
                  fontSize: AppFonts.h1_2FontSize,
                  fontWeight: FontWeight.bold,
                  color: blackTextColor,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isStudent
                      ? Container(
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
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, '/student/proposal/submit');
                            },
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero),
                              ),
                            ),
                            child: const Text(
                              'Reject',
                              style: TextStyle(
                                fontSize: 16,
                                color: blackTextColor,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Container(
                    width: 180,
                    height: 40,
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      border: Border.all(color: blackTextColor, width: 2.0),
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
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero),
                        ),
                      ),
                      child: const Text(
                        'Accept',
                        style: TextStyle(
                          fontSize: 16,
                          color: blackTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
