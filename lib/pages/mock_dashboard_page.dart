import 'package:flutter/material.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/custombottomnavbar.dart';

class MockDashboardPage extends StatelessWidget {
  const MockDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: AuthAppBar(),
      body: Column(
        children: [
          Text('This is fake Dashboard'),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        initialIndex: 1,
      ),
    );
  }
}
