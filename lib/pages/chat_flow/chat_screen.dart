import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({ super.key });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
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
        padding: const EdgeInsets.all(20),
        
      )
    )
  );
  }
}