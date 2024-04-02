import 'package:flutter/material.dart';
import '../../../components/appbar_ps1.dart';
class ProjectPostStep3Page extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return SafeArea(
        child: Scaffold(
          appBar: AppBar_PostPS1(),
          body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Padding(
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
                ),
                SizedBox(height: 20,),
                Text('Describe your project', style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 10,),
                TextField(
                  maxLines: 8,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
                SizedBox(height: 10,),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(onPressed: (){}, child: const Text('Review your post'), style: ElevatedButton.styleFrom(shape:RoundedRectangleBorder()),),
                )
                
              ],
            ),
          ),
        )
    );
  }
}