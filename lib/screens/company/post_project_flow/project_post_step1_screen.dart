import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:studenthub/components/appbar_ps1.dart';
import '../../../components/appbar_ps1.dart';
class ProjectPostStep1Page extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar_PostPS1(),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                SizedBox(height: 30,),
                Text('1/4 \t \t Let\'s start with a strong tittle', style: TextStyle(fontWeight: FontWeight.bold),),
                SizedBox(height: 30,),
                Center(
                  child: Text('This helps your post stand out to the right students. It\'s the first thing they\' see, so make it impressive!'),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Container(
                    child: TextField(
                        decoration: InputDecoration(
                        border:OutlineInputBorder(),
                        hintStyle: TextStyle(fontSize: 15),
                        isDense: true,
                        contentPadding: EdgeInsets.all(5),
                        hintText: 'write a title for jour post',
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30,),
                Text('Example titles', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                SizedBox(height: 10,),
                Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text('• Build responsive WordPress site with booking/payment functionality')
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text('• Facebook ad specialist need for product launch'),),
                SizedBox(height: 30,),
                Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(onPressed: (){}, child: const Text("Next: Score"), style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder()),)
                ),
              ],
            ),
      ),
    );
  }
}
