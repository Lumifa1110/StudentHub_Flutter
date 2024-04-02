import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studenthub/components/authappbar.dart';

class SubmitProposalScreen extends StatelessWidget {
  const SubmitProposalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthAppBar(canBack: false),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                'Cover letter',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Describe why do you fit to this project'),
              SizedBox(height: 10),
              Container(
                // height: 200, // Kích thước cụ thể
                child: const TextField(
                  maxLines: 10,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Cancel"),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder())),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                        onPressed: () {},
                        child: const Text("Submit proposal"),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder())),
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
