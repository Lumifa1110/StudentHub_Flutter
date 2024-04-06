import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studenthub/components/card_switchaccount.dart';
import 'package:studenthub/components/textfield/search_bar.dart';
import 'package:studenthub/enums/user_role.dart';
import 'package:studenthub/preferences/user_preferences.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class SwitchScreen extends StatefulWidget {
  const SwitchScreen({super.key});

  @override
  State<SwitchScreen> createState() => _SwitchScreenState();
}

class _SwitchScreenState extends State<SwitchScreen> {
  bool isSearchActive = false;
  UserRole? _userRole;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserRole();
  }

  Future<void> loadUserRole() async {
    UserRole? userRole = await UserPreferences.getUserRole();
    setState(() {
      _userRole = userRole;
    });
  }

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
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
                isSearchActive = !isSearchActive; // Toggle the search state
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
            const SingleChildScrollView(
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
            const Divider(
              color: blackTextColor,
              thickness: 3.0,
            ),
            Column(
              children: [
                InkWell(
                  onTap: () {
                    if (_userRole == UserRole.company) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const CompanyProfileInputScreen()));
                    } else if (_userRole == UserRole.student) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const StudentProfileInputScreen1()));
                    }
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
                  onTap: () {},
                  child: const ListTile(
                    leading: Icon(
                      Icons.logout,
                      size: 36,
                    ),
                    title: Text(
                      'Log out',
                      style: TextStyle(
                        fontSize: AppFonts.h3FontSize,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
