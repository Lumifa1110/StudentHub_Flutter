import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/components/textfield_floatinglabel.dart';
import 'package:studenthub/config/config.dart';
import 'package:studenthub/models/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  List<String> errorMessages = [];

  Future<void> _handleChangePassword() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final String? oldUser = prefs.getString('user');

    final String oldPassword = _oldPasswordController.text;
    final String newPassword = _newPasswordController.text;

    // HTTP request body
    final Map<String, String> data = {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    };

    // Send PUT request
    final http.Response response = await http.put(
      Uri.parse('$uriBase/api/user/changePassword'),
      body: jsonEncode(data),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final User user = User(
        email: jsonDecode(oldUser!)['email'],
        password: newPassword,
      );
      final userJson = user.toJson();
      await prefs.setString('user', jsonEncode(userJson));
      final List<String>? signedInAccountsJson = prefs.getStringList('signed_in_accounts');
      List<User> signedInAccounts = [];
      if (signedInAccountsJson != null) {
        signedInAccounts =
            signedInAccountsJson.map((json) => User.fromJson(jsonDecode(json))).toList();
      }
      User updatedUser = User(email: user.email, password: user.password);
      int existingAccountIndex = signedInAccounts.indexWhere(
        (account) => account.email == user.email,
      );
      signedInAccounts[existingAccountIndex] = updatedUser;
      await prefs.setString('user', jsonEncode(updatedUser.toJson()));
      await prefs.setStringList(
        'signed_in_accounts',
        signedInAccounts.map((account) => jsonEncode(account.toJson())).toList(),
      );
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Success'),
            content: const Text('Password changed successfully.'),
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
      }
    } else {
      // Show error dialog if request fails
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to change password. Please try again.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: const AuthAppBar(
        canBack: true,
        isShowIcon: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Container(),
              const Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: blackTextColor,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFieldFloatingLabel(
                label: 'Old Password',
                controller: _oldPasswordController,
                isPassword: true,
                hint: 'Enter Your Old Password',
              ),
              const SizedBox(
                height: 30,
              ),
              TextFieldFloatingLabel(
                label: 'New Password',
                controller: _newPasswordController,
                isPassword: true,
                hint: 'Enter Your New Password',
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  border: Border.all(color: lightgrayColor, width: 2.0),
                  color: mainColor,
                  boxShadow: const [
                    BoxShadow(
                      color: lightgrayColor,
                      offset: Offset(0, 0),
                      blurRadius: 1.0,
                      spreadRadius: 1.0,
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: () {
                    _handleChangePassword();
                  },
                  child: const Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 20,
                      color: whiteTextColor,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
