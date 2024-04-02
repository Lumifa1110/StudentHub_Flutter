import 'package:flutter/material.dart';
import 'package:studenthub/components/index.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CompanyProfileInputScreen extends StatefulWidget {
  const CompanyProfileInputScreen({super.key});

  @override
  State<CompanyProfileInputScreen> createState() => _CompanyProfileInputScreenState();
}

class _CompanyProfileInputScreenState extends State<CompanyProfileInputScreen> {
  // TextField controller
  final companyNameController = TextEditingController();
  final companyWebsiteController = TextEditingController();
  final companyDescriptionController = TextEditingController();

  String companySizeState = '';

  void handleCompanySizeChange(String? value) {
    setState(() {
      companySizeState = value!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Student Hub',
                  style: TextStyle(
                    color: Color(0xffffffff),
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            FaIcon(
              FontAwesomeIcons.solidUser,
              color: Color(0xffffffff),
              size: 24
            )
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column (
            children: [
              // TEXT: Welcome
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.topCenter,
                      child: const Text('Welcome to Student Hub!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ),
                  ),
                ]
              ),
              // TEXT: Guidance
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.topCenter,
                      child: const Text(
                        'Tell us about your company and you will be on your way connect with high skilled students',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal
                        ),
                      )
                    ),
                  ),
                ]
              ),
              // RADIO BUTTON: Select company size
              Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.topLeft,
                      child: const Text('How many people are there in your company?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal
                        ),
                      )
                    ),
                  ),
                ]
              ),
              Column (
                children: [
                  CompanySizeTile(
                    title: 'Only me', 
                    value: 'Only me', 
                    companySizeState: companySizeState, 
                    onChanged: handleCompanySizeChange
                  ),
                  CompanySizeTile(
                    title: '2 to 9 people', 
                    value: '2 to 9 people', 
                    companySizeState: companySizeState, 
                    onChanged: handleCompanySizeChange
                  ),
                  CompanySizeTile(
                    title: '10 to 99 people', 
                    value: '10 to 99 people', 
                    companySizeState: companySizeState, 
                    onChanged: handleCompanySizeChange
                  ),
                  CompanySizeTile(
                    title: '100 to 1000 people', 
                    value: '1000 to 1000 people', 
                    companySizeState: companySizeState, 
                    onChanged: handleCompanySizeChange
                  ),
                  CompanySizeTile(
                    title: 'Over 1000 people', 
                    value: 'Over 1000 people',
                    companySizeState: companySizeState, 
                    onChanged: handleCompanySizeChange
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // TextFields
              TextFieldWithLabel(label: 'Company name', controller: companyNameController, lineCount: 1),
              TextFieldWithLabel(label: 'Website', controller: companyWebsiteController, lineCount: 1),
              TextFieldWithLabel(label: 'Description', controller: companyDescriptionController, lineCount: 2),
              // Continue button
              
              Container(
                alignment: Alignment.bottomRight,
                margin: const EdgeInsets.only(top: 20),
                child: ButtonSimple(
                  label: 'Continue', 
                  onPressed: () => {
                    Navigator.pushNamed(context, '/company/welcome')
                  }
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}

class CompanySizeTile extends StatelessWidget {
  final String title;
  final String value;
  final String companySizeState;
  final ValueChanged<String?> onChanged;

  const CompanySizeTile({
    super.key,
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
        title: Text(
          title, 
          style: const TextStyle(
            fontSize: 14
          )
        ),
        leading: Radio(
          value: value,
          groupValue: companySizeState,
          onChanged: onChanged,
        ),
      ),
    );
  }
}