import 'package:flutter/material.dart';
import '../../../components/appbar_ps1.dart';
class ProjectPostStep3Page extends StatelessWidget{
  const ProjectPostStep3Page({super.key});

  @override
  Widget build(BuildContext context){
    return SafeArea(
        child: Scaffold(
          appBar: const AppBar_PostPS1(),
          body: Padding(
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
                  child: ElevatedButton(onPressed: (){}, style: ElevatedButton.styleFrom(shape:const RoundedRectangleBorder()), child: const Text('Review your post'),),
                )
                
              ],
            ),
          ),
        )
    );
  }
}