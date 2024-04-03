import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5.0,
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
            icon: Icon(Icons.search),
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
              padding: EdgeInsets.symmetric(horizontal: 20),
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
                    onTap: () {},
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
