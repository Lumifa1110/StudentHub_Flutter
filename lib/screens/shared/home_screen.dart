import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/enums/user_role.dart';
import 'package:studenthub/preferences/user_preferences.dart';
import 'package:studenthub/screens/authentication/signin_screen.dart';
import 'package:studenthub/utils/apiBase.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences _prefs;

  // @override
  // void initState() {
  //   super.initState();
  //   _loadToken();
  // }

  // Future<void> _loadToken() async {
  //   _prefs = await SharedPreferences.getInstance();
  //   final token = _prefs.getString('token');
  //   if (token != null) {
  //     Navigator.pushReplacementNamed(context, '/profile');
  //   }
  // }

  Future<void> handleCompany() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt('currentRole', UserRole.company.index);
    final profile = _prefs.getString('companyprofile');
    print(profile.runtimeType);
    print('Company: $profile');
    if (profile != null) {
      Navigator.pushReplacementNamed(context, '/list');
    } else {
      Navigator.pushNamed(context, '/company');
    }
  }

  Future<void> handleStudent() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setInt('currentRole', UserRole.company.index);
    final profile = _prefs.getString('studentprofile');
    print(profile.runtimeType);
    print('Student: $profile');
    if (profile != null) {
      Navigator.pushReplacementNamed(context, '/student/dashboard');
    } else {
      Navigator.pushNamed(context, '/student');
    }
  }

  Future<void> handleLogout() async {
    // Lấy token từ SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    print(token);

    if (token != null) {
      try {
        final response = await http.post(
          Uri.parse('${BASE_URL}auth/logout'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (response.statusCode == 201) {
          await prefs.remove('token');
          await prefs.remove('currentrole');
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
          automaticallyImplyLeading: false,
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
          actions: [
            IconButton(
              onPressed: handleLogout,
              icon: const Icon(
                Icons.logout,
                size: 26,
                color: whiteTextColor,
              ),
            ),
          ],
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Build your product with high-skilled student',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Find and onboard best-skilled student for your product. Student works to gain experience & skills from real-world project',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 40,
              ),
              Container(
                width: 180,
                height: 45,
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
                child: ElevatedButton(
                  onPressed: handleCompany,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(mainColor),
                  ),
                  child: const Text(
                    'Company',
                    style: TextStyle(
                      fontSize: 18,
                      color: whiteTextColor,
                    ),
                  ),
                ),
              ),
              // ElevatedButton(
              //     onPressed: () {},
              //     style: ElevatedButton.styleFrom(
              //       shape: const RoundedRectangleBorder(),
              //       fixedSize: const Size(150, 40),
              //     ),
              //     child: const Text("Student")),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 180,
                height: 45,
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
                child: ElevatedButton(
                  onPressed: handleStudent,
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(mainColor),
                  ),
                  child: const Text(
                    'Student',
                    style: TextStyle(
                      fontSize: 18,
                      color: whiteTextColor,
                    ),
                  ),
                ),
              ),
              // ElevatedButton(
              //     onPressed: () {},
              //     style: ElevatedButton.styleFrom(
              //       shape: const RoundedRectangleBorder(),
              //       fixedSize: const Size(150, 40),
              //     ),
              //     child: const Text("Student")),
              const SizedBox(
                height: 40,
              ),
              const Text(
                'StudentHub is university market place to connect high-skilled student and company on a real-world project',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        )));
  }
}
