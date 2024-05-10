import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/theme/theme_controller.dart';
import 'package:studenthub/utils/font.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late bool isDark = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  final MaterialStateProperty<Icon?> thumbIcon = MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(Icons.check);
      }
      return const Icon(Icons.close);
    },
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AuthAppBar(
        canBack: true,
        title: 'Setting',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Dark Mode',
                  style: TextStyle(fontSize: AppFonts.h1FontSize, fontWeight: FontWeight.w500),
                ),
                Consumer<ThemeController>(
                  builder: (context, themeController, _) {
                    return Switch(
                      value: themeController.themeMode == ThemeMode.dark,
                      onChanged: (value) {
                        themeController.toggleTheme(value);
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
