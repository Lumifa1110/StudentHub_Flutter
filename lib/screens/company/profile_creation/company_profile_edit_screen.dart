import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:studenthub/components/button_simple.dart';
import 'package:studenthub/components/textfield/textfield_label_v2.dart';
import 'package:studenthub/config/config.dart';
import 'package:studenthub/enums/company_size.dart';
import 'package:studenthub/models/company_profile_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:studenthub/utils/font.dart';

class CompanyProfileEditScreen extends StatefulWidget {
  const CompanyProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<CompanyProfileEditScreen> createState() =>
      _CompanyProfileEditScreenState();
}

class _CompanyProfileEditScreenState extends State<CompanyProfileEditScreen> {
  // TextField controller
  late SharedPreferences _prefs;
  final companyNameController = TextEditingController();
  final companyWebsiteController = TextEditingController();
  final companyDescriptionController = TextEditingController();

  CompanySize companySizeState = CompanySize.justme;

  void handleCompanySizeChange(CompanySize? value) {
    setState(() {
      companySizeState = value!;
    });
  }

  Future<void> postCompanyProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final company_profile = _prefs.getString('company_profile');
    final companyId = jsonDecode(company_profile!)['id'];
    print(token);
    final companyProfile = CompanyProfile(
      title: companyNameController.text,
      size: companySizeState.index,
      website: companyWebsiteController.text,
      description: companyDescriptionController.text,
    );

    final response = await http.put(
      Uri.parse(
          '$uriBase/api/profile/company/$companyId'), // Replace with your API endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(companyProfile.toJson()),
    );

    print(response.body);

    if (response.statusCode == 201 || response.statusCode == 200) {
      // Handle successful response
      final updatedCompanyProfile = jsonDecode(response.body)['result'];
      await prefs.setString(
          'company_profile', jsonEncode(updatedCompanyProfile));
      print('Company profile posted successfully');
    } else {
      // Handle error response
      print('Failed to post company profile');
    }
  }

  Future<void> _loadScreen() async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');
    final company_profile = _prefs.getString('company_profile');
    final companyId = jsonDecode(company_profile!)['id'];

    try {
      final response = await http.get(
        Uri.parse('$uriBase/api/profile/company/$companyId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      print(response.statusCode);
      print(response.body);

      if (response.statusCode == 200) {
        final companyData = jsonDecode(response.body)['result'];
        print(companyData);
        setState(() {
          companyNameController.text = companyData['companyName'] ?? '';
          companyWebsiteController.text = companyData['website'] ?? '';
          companyDescriptionController.text = companyData['description'] ?? '';
          companySizeState = CompanySize.values[companyData['size'] ?? 0];
        });
      } else {
        print('Failed to fetch company profile');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadScreen();
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
              // RADIO BUTTON: Select company size
              Row(children: [
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.topLeft,
                    child: const Text(
                      'How many people are there in your company?',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
              ]),
              Column(
                children: [
                  CompanySizeTile(
                    title: 'It\'s just me',
                    value: CompanySize.justme,
                    companySizeState: companySizeState,
                    onChanged: handleCompanySizeChange,
                  ),
                  CompanySizeTile(
                    title: '2 to 9 people',
                    value: CompanySize.small,
                    companySizeState: companySizeState,
                    onChanged: handleCompanySizeChange,
                  ),
                  CompanySizeTile(
                    title: '10 to 99 people',
                    value: CompanySize.medium,
                    companySizeState: companySizeState,
                    onChanged: handleCompanySizeChange,
                  ),
                  CompanySizeTile(
                    title: '100 to 1000 people',
                    value: CompanySize.large,
                    companySizeState: companySizeState,
                    onChanged: handleCompanySizeChange,
                  ),
                  CompanySizeTile(
                    title: 'Over 1000 people',
                    value: CompanySize.verylarge,
                    companySizeState: companySizeState,
                    onChanged: handleCompanySizeChange,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // TextFields
              TextFieldWithLabel2(
                label: 'Company name',
                controller: companyNameController,
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
                  onPressed: () => postCompanyProfile(),
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
