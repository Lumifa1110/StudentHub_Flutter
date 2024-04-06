import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/screens/index.dart';

class ProjectPostStep1Screen extends StatelessWidget{
  const ProjectPostStep1Screen({super.key});
  
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
                  const SizedBox(height: 30,),
                  const Text('1/4 \t \t Let\'s start with a strong tittle', style: TextStyle(fontWeight: FontWeight.bold),),
                  const SizedBox(height: 30,),
                  const Center(
                    child: Text('This helps your post stand out to the right students. It\'s the first thing they\' see, so make it impressive!'),
                  ),
                  const SizedBox(height: 10,),
                  const Center(
                    child: TextField(
                        decoration: InputDecoration(
                        border:OutlineInputBorder(),
                        hintStyle: TextStyle(fontSize: 15),
                        isDense: true,
                        contentPadding: EdgeInsets.all(5),
                        hintText: 'write a title for your post',
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  const Text('Example titles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  const SizedBox(height: 10,),
                  const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('• Build responsive WordPress site with booking/payment functionality')
                  ),
                  const Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Text('• Facebook ad specialist need for product launch'),),
                  const SizedBox(height: 30,),
                  Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, PageTransition(
                            type: PageTransitionType.rightToLeft, 
                            child: const ProjectPostStep2Screen()
                          ));
                        }, 
                        style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()), 
                        child: const Text("Next: Score")
                      )
                  ),
                ],
              ),
        ),
      ),
    );
  }
}
