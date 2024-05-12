import 'package:flutter/material.dart';
import 'package:studenthub/enums/user_role.dart';
import 'package:studenthub/preferences/user_preferences.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/utils/font.dart';

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
  UserRole? _userRole;
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    loadUserRole();
    _selectedIndex = widget.initialIndex;
  }

  Future<void> loadUserRole() async {
    UserRole? userRole = await UserPreferences.getUserRole();
    setState(() {
      _userRole = userRole;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1), // Shadow color
            spreadRadius: 2.0, // Spread radius
            blurRadius: 2.0, // Blur radius
            offset: const Offset(0, -1), // Offset from the bottom
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        type: BottomNavigationBarType.fixed,
        iconSize: 24,
        selectedFontSize: AppFonts.h3FontSize,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        unselectedFontSize: AppFonts.h3FontSize,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        currentIndex: _selectedIndex,
        onTap: (newIndex) {
          if (newIndex == _selectedIndex) return;
          setState(() {
            _selectedIndex = newIndex;
          });
          switch (newIndex) {
            case 0:
              {
                _navigateWithAnimation(
                    '/list', const ProjectListScreen(), widget.initialIndex, newIndex);
                break;
              }
            case 1:
              {
                if (_userRole == UserRole.company) {
                  _navigateWithAnimation('/company/dashboard', const CompanyDashboardScreen(),
                      widget.initialIndex, newIndex);
                } else if (_userRole == UserRole.student) {
                  _navigateWithAnimation('/student/dashboard', const StudentDashboardScreen(),
                      widget.initialIndex, newIndex);
                }
                break;
              }
            case 2:
              {
                _navigateWithAnimation(
                    '/message', const MessageListScreen(), widget.initialIndex, newIndex);
                break;
              }
            case 3:
              {
                _navigateWithAnimation(
                    '/notification', const NotificationScreen(), widget.initialIndex, newIndex);
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

  void _navigateWithAnimation(String routeName, Widget widgetname, int currentindex, int newindex) {
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

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }
}
