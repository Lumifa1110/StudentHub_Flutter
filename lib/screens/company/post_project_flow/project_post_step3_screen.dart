import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/screens/index.dart';

class ProjectPostStep3Screen extends StatelessWidget{
  const ProjectPostStep3Screen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: const AuthAppBar(canBack: true, title: 'Post project'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(right: 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('3/4       Next, provide project description', style: TextStyle(fontWeight: FontWeight.bold),),
                    SizedBox(height: 30,),
                    Text('Students are looking for'),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('• Clear expectation about your project or deliverables'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('• The skills required for your project'),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('• Detail about your project'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              const Text('Describe your project', style: TextStyle(fontWeight: FontWeight.bold),),
              const SizedBox(height: 10,),
              const TextField(
                maxLines: 8,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 10,),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(context, PageTransition(
                      type: PageTransitionType.rightToLeft, 
                      child: const ProjectPostStep4Screen(
                        'Web Front-end Developer',
                        6,
                        '3 to 6 months',
                        'description'
                      )
                    ));
                  }, 
                  style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()), 
                  child: const Text('Review your post')
                ),
              )
              
            ],
          ),
        ),
      ),
    );
  }
}