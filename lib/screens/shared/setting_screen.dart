import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studenthub/components/authappbar.dart';
import 'package:studenthub/theme/theme_controller.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  late bool isDark = false;

  @override
  void initState() {
    super.initState();
  }

  final MaterialStateProperty<Icon?> thumbIcon = MaterialStateProperty.resolveWith<Icon?>(
    (Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Icon(
          Icons.check,
          color: whiteTextColor,
        );
      }
      return const Icon(
        Icons.close,
        color: whiteTextColor,
      );
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
                      thumbIcon: thumbIcon,
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
