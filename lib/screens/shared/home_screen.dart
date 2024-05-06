import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/enums/user_role.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/services/index.dart';
import 'package:studenthub/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late SharedPreferences prefs;

  Future<void> handleCompany() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_role', UserRole.company.index);
    final profile = prefs.getString('company_profile');
    if (mounted) {
      if (profile == 'null') {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CompanyProfileInputScreen()),
        );
        if (result == true) {
          await _loadScreen();
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const CompanyDashboardScreen()));
      }
      // final result = await Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const CompanyDashboardScreen()),
      // );
      // print(result);
    }
  }

  Future<void> handleStudent() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.setInt('current_role', UserRole.student.index);
    final profile = prefs.getString('student_profile');
    if (mounted) {
      if (profile == 'null') {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StudentProfileInputScreen1()),
        );
        if (result == true) {
          await _loadScreen();
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const StudentDashboardScreen()));
      }
      // final result = await Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const StudentDashboardScreen()),
      // );
      // print(result);
    }
  }

  Future<void> handleLogout() async {
    final prefs = await SharedPreferences.getInstance();

    // API: log out
    await AuthService.logOut();

    // DELETE LOCAL: token + current role
    await prefs.remove('token');
    await prefs.remove('current_role');

    // NAVIGATE TO: sign in screen
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SigninScreen()),
      );
    }
  }

  Future<void> _loadScreen() async {
    print('home');
    prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == 'null') {
      // Xóa current_role trong local
      // Chuyển hướng đến màn hình SigninScreen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SigninScreen()),
        );
      }
    } else {
      await prefs.remove('current_role');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AuthAppBar(
          canBack: false,
          onRoleChanged: (result) {
            print(result);
            _loadScreen();
          },
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
                    backgroundColor: MaterialStateProperty.all<Color>(mainColor),
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
                    backgroundColor: MaterialStateProperty.all<Color>(mainColor),
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
