import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/button_simple.dart';
import 'package:studenthub/components/textfield/textfield_label_v2.dart';
import 'package:studenthub/enums/company_size.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/services/index.dart';
import 'package:studenthub/utils/font.dart';

class CompanyProfileInputScreen extends StatefulWidget {
  const CompanyProfileInputScreen({super.key});

  @override
  State<CompanyProfileInputScreen> createState() =>
      _CompanyProfileInputScreenState();
}

class _CompanyProfileInputScreenState extends State<CompanyProfileInputScreen> {
  // TextField controller
  final companyNameController = TextEditingController();
  final companySizeController = TextEditingController();
  final companyWebsiteController = TextEditingController();
  final companyDescriptionController = TextEditingController();

  Future<void> postCompanyProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final companyProfile = prefs.getString('company_profile');

    // API: create company profile
    if (companyProfile == 'null') {
      final Map<String, dynamic> companyProfileResponse = await CompanyService.addCompanyProfile({
        "companyName": companyNameController.text,
        "size": int.parse(companySizeController.text),
        "website": companyWebsiteController.text,
        "description": companyDescriptionController.text
      });
      await prefs.setString('company_profile', jsonEncode(companyProfileResponse));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(canBack: true),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            children: [
              // TEXT: Welcome
              Row(children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.topCenter,
                    child: const Text(
                      'Welcome to Student Hub!',
                      style: TextStyle(
                          fontSize: AppFonts.h1FontSize,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]),
              // TEXT: Guidance
              Row(children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.topCenter,
                    child: const Text(
                      'Tell us about your company and you will be on your way connect with high skilled students',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ]),
              // TextFields
              TextFieldWithLabel2(
                label: 'Company name',
                controller: companyNameController,
              ),
              TextFieldWithLabel2(
                label: 'Company size',
                controller: companySizeController,
              ),
              TextFieldWithLabel2(
                label: 'Website',
                controller: companyWebsiteController,
              ),
              TextFieldWithLabel2(
                label: 'Description',
                controller: companyDescriptionController,
              ),
              // Continue button
              Container(
                alignment: Alignment.bottomRight,
                margin: const EdgeInsets.only(top: 20),
                child: ButtonSimple(
                  label: 'Continue',
                  onPressed: () => {
                    postCompanyProfile(),
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CompanyWelcomeScreen()))
                  },
                  isButtonEnabled: true,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CompanySizeTile extends StatelessWidget {
  final String title;
  final CompanySize value;
  final CompanySize companySizeState;
  final ValueChanged<CompanySize?> onChanged;

  const CompanySizeTile({
    Key? key,
    required this.title,
    required this.value,
    required this.companySizeState,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: const TextStyle(fontSize: 16)),
        leading: Radio(
          value: value,
          groupValue: companySizeState,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
