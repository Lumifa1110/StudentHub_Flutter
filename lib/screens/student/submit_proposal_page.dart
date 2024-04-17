import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class SubmitProposalScreen extends StatelessWidget {
  const SubmitProposalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(canBack: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Cover letter',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: AppFonts.h2FontSize),
              ),
              const SizedBox(height: 10),
              const Text(
                'Describe why do you fit to this project',
                style: TextStyle(
                    fontSize: AppFonts.h3FontSize, color: blackTextColor),
              ),
              const SizedBox(height: 10),
              const TextField(
                maxLines: 10,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(),
                          backgroundColor: mainColor,
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                              fontSize: AppFonts.h3FontSize,
                              color: whiteTextColor),
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(),
                        backgroundColor: mainColor,
                      ),
                      child: const Text(
                        "Submit proposal",
                        style: TextStyle(
                            fontSize: AppFonts.h3FontSize,
                            color: whiteTextColor),
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
