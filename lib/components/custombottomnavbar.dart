import 'package:flutter/material.dart';
import 'package:studenthub/pages/mock_dashboard_page.dart';
import 'package:studenthub/pages/mock_message_page.dart';
import 'package:studenthub/pages/notification_page.dart';
import 'package:studenthub/pages/project_list_page.dart';
import 'package:studenthub/utils/colors.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int initialIndex;

  const CustomBottomNavBar({
    super.key,
    required this.initialIndex,
  });

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: mainColor,
      iconSize: 30,
      unselectedFontSize: 16,
      selectedFontSize: 16,
      currentIndex: _selectedIndex,
      onTap: (newIndex) {
        if (newIndex == _selectedIndex) return;
        setState(() {
          _selectedIndex = newIndex;
        });
        switch (newIndex) {
          case 0:
            {
              _navigateWithAnimation('/list', const ProjectListPage(),
                  widget.initialIndex, newIndex);
              break;
            }
          case 1:
            {
              _navigateWithAnimation('/dashboard', const MockDashboardPage(),
                  widget.initialIndex, newIndex);
              break;
            }
          case 2:
            {
              _navigateWithAnimation('/message', const MessagePage(),
                  widget.initialIndex, newIndex);
              break;
            }
          case 3:
            {
              _navigateWithAnimation('/notification', NotificationPage(),
                  widget.initialIndex, newIndex);
              break;
            }
          // Add cases for additional pages if needed
        }
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
            child: Icon(Icons.message_outlined),
          ),
          label: 'Message',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 3),
            child: Icon(Icons.notifications),
          ),
          label: 'Alerts',
        ),
      ],
    );
  }

  void _navigateWithAnimation(
      String routeName, Widget widgetname, int currentindex, int newindex) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => widgetname,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = const Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;
          if (newindex < currentindex) {
            begin = const Offset(-1.0, 0.0);
          }

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}
