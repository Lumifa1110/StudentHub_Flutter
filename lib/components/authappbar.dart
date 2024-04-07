import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/utils/colors.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool canBack;
  final String? title;

  const AuthAppBar({
    Key? key, // Add Key? key here
    required this.canBack,
    this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    void _navigateWithAnimation(String routeName, Widget widgetname) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => widgetname,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    }

    Future<void> handlePressIcon() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        _navigateWithAnimation('/profile', SwitchScreen());
      }
    }

    return AppBar(
      leadingWidth: 20,
      leading: canBack
          ? IconButton(
              icon: const Icon(Icons.chevron_left, color: whiteTextColor),
              onPressed: () => Navigator.of(context).pop(),
            )
          : null,
      elevation: 5.0,
      // automaticallyImplyLeading: canBack,
      automaticallyImplyLeading: canBack,
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                color: whiteTextColor,
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            )
          : const Row(
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
          onPressed: handlePressIcon,
          icon: const Icon(
            Icons.person,
            size: 26,
            color: blackTextColor,
          ),
        )
      ],
    );
  }
}
