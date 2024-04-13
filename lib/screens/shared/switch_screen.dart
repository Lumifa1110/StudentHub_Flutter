import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:studenthub/components/card_switchaccount.dart';
import 'package:studenthub/components/textfield/search_bar.dart';
import 'package:studenthub/config/config.dart';
import 'package:studenthub/preferences/index.dart';
import 'package:studenthub/screens/shared/project_list_screen.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class SwitchScreen extends StatefulWidget {
  final bool isDashboard;

  const SwitchScreen({super.key, this.isDashboard = false});

  @override
  State<SwitchScreen> createState() => _SwitchScreenState();
}

class _SwitchScreenState extends State<SwitchScreen> {
  bool isSearchActive = false;
  final TextEditingController searchController = TextEditingController();
  List<String> _roles = [];
  int? _currentRole;
  String? _accountFullname;

  @override
  void initState() {
    super.initState();
    _loadRoles().then((_) {
      _loadCurrentData().then((_) {
        _check();
      });
    });
  }

  Future<void> _loadRoles() async {
    final prefs = await SharedPreferences.getInstance();
    final rolesList = prefs.getStringList('roles');

    if (rolesList != null) {
      // Remove duplicates
      final uniqueRoles = rolesList.toSet().toList();
      setState(() {
        _roles = uniqueRoles;
      });
    }
  }

  Future<void> _loadCurrentData() async {
    final prefs = await SharedPreferences.getInstance();
    final currRole = prefs.getInt('current_role');
    final accName = prefs.getString('username');
    if (currRole != null) {
      setState(() {
        _currentRole = currRole;
        _accountFullname = accName;
      });
    }
  }

  void _check() {
    setState(() {
      print('List roles: $_roles');
      print('User selected role: $_currentRole');
      print(widget.isDashboard);
    });
  }

  void _handleRoleSelection(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_role', int.parse(role));

    // Update the current role in the app state
    setState(() {
      _currentRole = int.parse(role);
      print(UserPreferences.getUserRole());
    });
  }

  Future<void> handleLogout() async {
    // Lấy token từ SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('${uriBase}/api/auth/logout'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 201) {
          // await prefs.remove('token');
          // await prefs.remove('currole');
          await prefs.clear();
          Navigator.pushReplacementNamed(context, '/signin');
        } else {
          // Xử lý lỗi nếu cần
          print('Logout failed: ${response.body}');
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Token not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
        leadingWidth: 40,
        leading: Navigator.canPop(context)
            ? SizedBox(
                width: kToolbarHeight,
                height: kToolbarHeight,
                child: Material(
                  borderRadius: BorderRadius.zero,
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (widget.isDashboard) {
                        Navigator.of(context).pop();
                        if (_currentRole == 0) {
                          Navigator.pushReplacementNamed(
                              context, '/student/dashboard');
                        } else if (_currentRole == 1) {
                          Navigator.pushReplacementNamed(
                              context, '/company/dashboard');
                        }
                      } else {
                        Navigator.of(context).pop(true);
                      }
                    },
                    child: const Center(
                      child: Icon(
                        Icons.chevron_left,
                        color: whiteTextColor,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              )
            : null,
        title: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Accounts',
              style: TextStyle(
                color: whiteTextColor,
                fontSize: AppFonts.h1FontSize,
              ),
            )
          ],
        ),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.blue,
        ),
        backgroundColor: mainColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {
              setState(() {
                isSearchActive = !isSearchActive;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            isSearchActive
                ? CustomSearchBar(
                    controller: searchController, placeholder: 'Search...')
                : const SizedBox(
                    height: 10,
                  ),
            SingleChildScrollView(
              child: Column(
                children: [
                  for (var role in _roles)
                    CardSwitchAccount(
                      accountAvt: Icons.person,
                      accountFullname: _accountFullname ?? '',
                      accountRole: role,
                      isSelected: role == _currentRole.toString(),
                      onTap: () => _handleRoleSelection(role),
                    ),
                ],
              ),
            ),
            const Divider(
              color: blackTextColor,
              thickness: 3.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: const ListTile(
                      leading: Icon(
                        Icons.person_2_outlined,
                        size: 36,
                      ),
                      title: Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: AppFonts.h3FontSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const ListTile(
                      leading: Icon(
                        Icons.settings,
                        size: 36,
                      ),
                      title: Text(
                        'Setting',
                        style: TextStyle(
                          fontSize: AppFonts.h3FontSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: handleLogout,
                    child: const ListTile(
                      leading: Icon(
                        Icons.logout,
                        size: 36,
                      ),
                      title: Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: AppFonts.h2FontSize,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
