import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/screens/index.dart';

class ProjectPostStep2Screen extends StatelessWidget{
  const ProjectPostStep2Screen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: const AuthAppBar(canBack: true, title: 'Post project'),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 30,),
                const Text('2/4 \t\t Next, estimate the scope of your job', style: TextStyle(fontWeight: FontWeight.bold),),
                const SizedBox(height: 10,),
                const Text('Consider the size of your project and the timeline'),
                const SizedBox(height: 30,),
                const Text('How long will your project take?'),
                const SizedBox(height: 20,),
                CheckboxListPrPS2(),
                const SizedBox(height: 20,),
                const Text('How many students do you want for this project?'),
                const SizedBox(height: 20,),
                const TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'number of students',
                    hintStyle: TextStyle(fontSize: 15),
                    isDense: true,
                    contentPadding: EdgeInsets.all(5)
                  ),
                ),
                const SizedBox(height: 40,),
                Align(
                  alignment: Alignment.centerRight,
                  child:ElevatedButton(
                    onPressed: (){
                      Navigator.push(context, PageTransition(
                        type: PageTransitionType.rightToLeft, 
                        child: const ProjectPostStep3Screen()
                      ));
                    },
                    style: ElevatedButton.styleFrom(shape: const RoundedRectangleBorder()),
                    child: const Text('Next: Description'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum radius_value{to3, to6}
class CheckboxListPrPS2 extends StatefulWidget{
  @override
  _CheckboxListPrPS2State createState()=> _CheckboxListPrPS2State();
}
class _CheckboxListPrPS2State extends State<CheckboxListPrPS2>{
  radius_value _isChecked = radius_value.to3;
  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('1 to 3 months', style: TextStyle(fontSize: 14),),
          leading: Radio(
            value: radius_value.to3,
            groupValue: _isChecked,
            onChanged: (value){
              setState(() {
                _isChecked = value as radius_value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('3 to 6 months', style: TextStyle(fontSize: 14)),
          leading: Radio(
            value: radius_value.to6,
            groupValue: _isChecked,
            onChanged: (value){
              setState(() {
                _isChecked = value as radius_value;
              });
            },
          ),
        )
      ],
    );
  }
}