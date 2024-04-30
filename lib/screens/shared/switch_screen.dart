import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:studenthub/components/card_switchaccount.dart';
import 'package:studenthub/components/textfield/search_bar.dart';
import 'package:studenthub/config/config.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/preferences/index.dart';
import 'package:studenthub/screens/company/profile_creation/company_profile_edit_screen.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/screens/student/profile_creation/student_profile_input_screen_1.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

import '../../services/index.dart';

class SwitchScreen extends StatefulWidget {
  final bool isDashboard;

  const SwitchScreen({super.key, this.isDashboard = false});

  @override
  State<SwitchScreen> createState() => _SwitchScreenState();
}

class _SwitchScreenState extends State<SwitchScreen> {
  late SharedPreferences _prefs;
  bool isSearchActive = false;
  final TextEditingController searchController = TextEditingController();
  List<String> _roles = [];
  List<User> _signedInAccounts = [];
  int? _currentRole;
  String? _accountFullname;
  String? _accountEmail;
  String? selectedProfileAction;
  // Define a list of profile actions
  final List<String> profileActions = ["My Profile", "Change Password"];

  // Define a variable to track the selected action

  @override
  void initState() {
    super.initState();
    _loadSignedInAccounts();
    _loadRoles().then((_) {
      _loadCurrentData().then((_) {
        _check();
      });
    });
  }

  Future<void> _loadRoles() async {
    _prefs = await SharedPreferences.getInstance();
    final rolesList = _prefs.getStringList('roles');

    if (rolesList != null) {
      // Remove duplicates
      final uniqueRoles = rolesList.toSet().toList();
      setState(() {
        _roles = uniqueRoles;
      });
    }
  }

  Future<void> _loadSignedInAccounts() async {
    _prefs = await SharedPreferences.getInstance();
    final List<String>? signedInAccountsJson = _prefs.getStringList('signed_in_accounts');
    final String? user = _prefs.getString('user');

    _accountEmail = jsonDecode(user!)['email'];
    if (signedInAccountsJson != null) {
      setState(() {
        _signedInAccounts =
            signedInAccountsJson.map((json) => User.fromJson(jsonDecode(json))).toList();
      });
    }
  }

  Future<void> _loadCurrentData() async {
    _prefs = await SharedPreferences.getInstance();
    final currRole = _prefs.getInt('current_role');
    final accName = _prefs.getString('username');
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

  void _navigateToProfile() {
    final currole = _prefs.getInt('current_role');
    if (currole == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const StudentProfileInputScreen1()));
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const CompanyProfileEditScreen()));
    }
  }

  void _handleRoleSelection(String role) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt('current_role', int.parse(role));

    // Update the current role in the app state
    setState(() {
      _currentRole = int.parse(role);
      print(UserPreferences.getUserRole());
    });
  }

  void _handleAccountSwitch(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final existToken = _prefs.getString('token');
    if (existToken != null) {
      try {
        final response = await http.post(
          Uri.parse('$uriBase/api/auth/logout'),
          headers: {
            'Authorization': 'Bearer $existToken',
          },
        );

        if (response.statusCode == 201) {
          final keys = _prefs.getKeys();
          for (final key in keys) {
            if (key != 'signed_in_accounts') {
              await _prefs.remove(key);
            }
          }
        } else {
          print('Logout failed: ${response.body}');
        }
      } catch (e) {
        print('Error: $e');
      }
    } else {
      print('Token not found');
    }

    final User user = User(
      email: email,
      password: password,
    );

    final Map<String, dynamic> signInResponse = await AuthService.signIn(
      {
        "email": email,
        "password": password,
      },
    );

    if (signInResponse['result'] == null) {
    } else {
      // SAVE LOCAL: email + password
      final userJson = user.toJson();
      await prefs.setString('user', jsonEncode(userJson));

      // Retrieve existing signed-in accounts
      final List<String>? signedInAccountsJson = prefs.getStringList('signed_in_accounts');
      List<User> signedInAccounts = [];
      if (signedInAccountsJson != null) {
        signedInAccounts =
            signedInAccountsJson.map((json) => User.fromJson(jsonDecode(json))).toList();
      }
      // Check if the signed-in user's email already exists in the list of signed-in accounts
      bool accountExists = signedInAccounts.any((account) => account.email == user.email);
      if (!accountExists) {
        // Account have not existed
        // Add new account
        final userJson = user.toJson();
        await prefs.setString('user', jsonEncode(userJson));
        signedInAccounts.add(User(email: user.email, password: user.password));
        await prefs.setStringList(
          'signed_in_accounts',
          signedInAccounts.map((account) => jsonEncode(account.toJson())).toList(),
        );
      } else {
        // Account already exists
        // Find the existing account
        int existingAccountIndex = signedInAccounts.indexWhere(
          (account) => account.email == user.email,
        );
        if (signedInAccounts[existingAccountIndex].password != user.password) {
          // Create new updated acc and replace
          User updatedUser = User(email: user.email, password: user.password);
          signedInAccounts[existingAccountIndex] = updatedUser;
          await prefs.setString('user', jsonEncode(updatedUser.toJson()));
          await prefs.setStringList(
            'signed_in_accounts',
            signedInAccounts.map((account) => jsonEncode(account.toJson())).toList(),
          );
        }
      }

      final token = signInResponse['result']['token'];
      await prefs.setString('token', token);

      // FETCH: user data
      await fetchUserData();

      // NAVIGATE TO: home screen
      if (mounted) {
        while (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomeScreen()));
      }
    }
  }

  Future<void> fetchUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      // API: get user data
      final Map<String, dynamic> response = await AuthService.getUserInfo();
      final userData = response['result'];

      // SAVE LOCAL: user id + fullname + roles
      await prefs.setInt('userid', userData['id']);
      await prefs.setString('username', userData['fullname']);
      List<dynamic> roles = userData['roles'];
      List<String> rolesStringList = roles.map((role) => role.toString()).toList();
      await prefs.setStringList('roles', rolesStringList);

      // SAVE LOCAL: user profiles
      await prefs.setString('student_profile', jsonEncode(userData['student']));
      print(jsonEncode(userData['student']));
      await prefs.setString('company_profile', jsonEncode(userData['company']));
      print(jsonEncode(userData['company']));
    } else {
      // Handle case where token is not available
    }
  }

  Future<void> handleLogout() async {
    // Lấy token từ SharedPreferences
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs.getString('token');

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('$uriBase/api/auth/logout'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 201) {
          final keys = _prefs.getKeys();
          for (final key in keys) {
            if (key != 'signed_in_accounts') {
              await _prefs.remove(key);
            }
          }
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
      backgroundColor: bgColor,
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
                          Navigator.pushReplacementNamed(context, '/student/dashboard');
                        } else if (_currentRole == 1) {
                          Navigator.pushReplacementNamed(context, '/company/dashboard');
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
                ? CustomSearchBar(controller: searchController, placeholder: 'Search...')
                : const SizedBox(
                    height: 10,
                  ),
            _roles.isNotEmpty && _currentRole != null
                ? SingleChildScrollView(
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
                  )
                : const SizedBox(
                    height: 50,
                  ),
            _signedInAccounts.isNotEmpty
                ? Column(
                    children: _signedInAccounts.map((account) {
                      return CardSwitchAccount(
                        accountAvt: Icons.person,
                        accountFullname: account.email,
                        accountRole: 'Role',
                        isSelected: _accountEmail == account.email,
                        onTap: () {
                          _handleAccountSwitch(account.email, account.password);
                        },
                      );
                    }).toList(),
                  )
                : SizedBox(),
            const Divider(
              color: blackTextColor,
              thickness: 3.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      if (_currentRole == null) return;
                      _navigateToProfile();
                    },
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
                    onTap: () {
                      Navigator.pushNamed(context, '/user/changepassword');
                    },
                    child: const ListTile(
                      leading: Icon(
                        Icons.lock,
                        size: 36,
                      ),
                      title: Text(
                        'Change Password',
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
