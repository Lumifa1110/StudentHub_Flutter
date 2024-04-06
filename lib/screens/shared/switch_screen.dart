import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:studenthub/components/card_switchaccount.dart';
import 'package:studenthub/components/textfield/search_bar.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class SwitchScreen extends StatefulWidget {
  const SwitchScreen({Key? key}) : super(key: key);

  @override
  State<SwitchScreen> createState() => _SwitchScreenState();
}

class _SwitchScreenState extends State<SwitchScreen> {
  bool isSearchActive = false;
  List<String> roles = [];
  int? currentRole;

  @override
  void initState() {
    super.initState();
    _loadRoles().then((_) {
      _loadCurrentRole().then((_) {
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
        roles = uniqueRoles;
      });
    }
  }

  Future<void> _loadCurrentRole() async {
    final prefs = await SharedPreferences.getInstance();
    final curRole = prefs.getInt('currole');
    if (curRole != null) {
      setState(() {
        currentRole = curRole;
      });
    }
  }

  void _check() {
    setState(() {
      print('This is list roles: $roles');
      print('This is user selected role: $currentRole');
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
          Uri.parse('http://34.16.137.128/api/auth/logout'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 201) {
          await prefs.remove('token');
          await prefs.remove('currole');
          Navigator.pushReplacementNamed(context, '/');
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
        leadingWidth: 20,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.chevron_left, color: whiteTextColor),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: const Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Student',
              style: TextStyle(
                color: whiteTextColor,
                fontSize: 26,
              ),
            ),
            Text(
              'Hub',
              style: TextStyle(
                color: blackTextColor,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                ? const ChatSearchBar(placeholder: 'Search...')
                : const SizedBox(
                    height: 10,
                  ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CardSwitchAccount(
                        accountAvt: Icons.person,
                        accountName: 'Luu Minh Phat',
                        accountRole: 'Company'),
                    CardSwitchAccount(
                        accountAvt: Icons.person,
                        accountName: 'Luu Minh Phat Student',
                        accountRole: 'Student'),
                  ],
                ),
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
                          fontSize: AppFonts.h2FontSize,
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
                          fontSize: AppFonts.h2FontSize,
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
