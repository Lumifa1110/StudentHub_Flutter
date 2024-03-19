import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AuthAppBar(canBack: false),
      body: Column(
        children: [
          Text('This is fake Message'),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        initialIndex: 2,
      ),
    );
  }
}
