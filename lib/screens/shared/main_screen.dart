import 'package:flutter/material.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: const [
          ProjectListScreen(),
          CompanyDashboardScreen(),
          MessageListScreen(),
          NotificationScreen()
        ]
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 24,
        selectedFontSize: AppFonts.h3FontSize,
        selectedItemColor: AppColor.primary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        unselectedFontSize: AppFonts.h3FontSize,
        unselectedItemColor: AppFonts.secondaryColor,
        currentIndex: selectedIndex,
        onTap: (newIndex) {
          if (newIndex == selectedIndex) return;
          setState(() {
            selectedIndex = newIndex;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Icon(
                Icons.list_alt,
              ),
            ),
            label: 'Project',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Icon(
                Icons.dashboard_customize,
              ),
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Icon(
                Icons.message_outlined,
              ),
            ),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 3),
              child: Icon(
                Icons.notifications,
              ),
            ),
            label: 'Alerts',
          ),
        ],
      ),
    ); 
  }
}