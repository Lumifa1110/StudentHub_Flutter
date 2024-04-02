import 'package:flutter/material.dart';
import '../../../components/appbar_ps1.dart';
class ProjectPostStep2Page extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return SafeArea(
        child: Scaffold(
          appBar: AppBar_PostPS1(),
          body: Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 30,),
                  Text('2/4 \t\t Next, estimate the scope of your job', style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(height: 10,),
                  Text('Consider the size of your project and the timeline'),
                  SizedBox(height: 30,),
                  Text('How long will your project take?'),
                  SizedBox(height: 20,),
                  CheckboxListPrPS2(),
                  SizedBox(height: 20,),
                  Text('How many students do you want for this project?'),
                  SizedBox(height: 20,),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'number of students',
                      hintStyle: TextStyle(fontSize: 15),
                      isDense: true,
                      contentPadding: EdgeInsets.all(5)
                    ),
                  ),
                  SizedBox(height: 40,),
                  Align(
                    alignment: Alignment.centerRight,
                    child:ElevatedButton(
                      onPressed: (){},
                      child: Text('Next: Description'),
                      style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder()),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
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
                this._isChecked = value as radius_value;
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
                this._isChecked = value as radius_value;
              });
            },
          ),
        )
      ],
    );
  }
}