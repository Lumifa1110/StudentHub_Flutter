import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:http/http.dart' as http;
import 'package:studenthub/config/config.dart';


class ForgotPasswordScreen extends StatefulWidget{
  @override
  State<ForgotPasswordScreen> createState() => StateForgotPasswordScreen();
}

class StateForgotPasswordScreen extends State<ForgotPasswordScreen>{
  final TextEditingController _emailEnter = TextEditingController();
  bool _erro = false;

  Future<void> postForgotPassword(BuildContext context) async {

    Map<String, dynamic> emailForgotPassword = {"email" : _emailEnter.text};
    try {
      final response = await http.post(
        Uri.parse('$uriBase/api/user/forgotPassword'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(emailForgotPassword),
      );
      if (response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Success'),
            content: const Text('We have send a new password to your email.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                  Navigator.of(context).pop(true);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: const Text('The email you just entered does not exist. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
    } catch (e) {
      print(e);
    }
  }
  void _fValiteDate(String value) {
    setState(() {
      _erro = value.isEmpty;
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: const AuthAppBar(
        canBack: false,
        isShowIcon: false,
      ),
      body: Container(
        height:  MediaQuery.sizeOf(context).height*2/7,
        width: MediaQuery.sizeOf(context).width*3/4,
        margin: EdgeInsets.only(left: MediaQuery.sizeOf(context).width*1/8, top: MediaQuery.sizeOf(context).height*1/6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black
          )
        ),
        child:Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2 ,
                  child: Text("Find your account password", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
              ),
              Expanded(
                flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Please enter your email to find your account password.", style: TextStyle(fontSize: 12)),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        style: TextStyle(fontSize: 12),
                        controller: _emailEnter,
                        onChanged: _fValiteDate,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintStyle: const TextStyle(fontSize: 12),
                          isDense: true,
                          contentPadding: const EdgeInsets.all(10),
                          errorText: _erro ? 'Please enter a email' : null,
                          hintText: 'Email',
                          // fon
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                              onPressed: (){
                                Navigator.of(context).pushNamed('/signin');
                              },
                              child: Text('Cancel')
                          ),
                          SizedBox(width: 5,),
                          ElevatedButton(
                              onPressed: (){
                                postForgotPassword(context);
                              },
                              child: Text('Confirm')
                          ),
                        ],
                      ),
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}