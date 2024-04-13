import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool canBack;
  final String? title;
  final bool isShowIcon;
  final bool? isFromDashBoard;
  final Function(bool)? onRoleChanged;

  const AuthAppBar({
    Key? key,
    required this.canBack,
    this.title,
    this.isShowIcon = true,
    this.isFromDashBoard = false,
    this.onRoleChanged,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    void _navigateWithAnimation(String routeName, Widget widgetname) async {
      final result = await Navigator.of(context).push(
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
      print('Back Result $result');

      if (result != null && onRoleChanged != null) {
        onRoleChanged!(result);
      }
    }

    Future<void> handlePressIcon() async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      print(token);
      if (token != null) {
        if (isFromDashBoard == true) {
          _navigateWithAnimation(
              '/profile',
              const SwitchScreen(
                isDashboard: true,
              ));
        } else {
          _navigateWithAnimation('/profile', const SwitchScreen());
        }
      }
    }

    return AppBar(
      backgroundColor: mainColor,
      leadingWidth: 40,
      leading: canBack && Navigator.canPop(context)
          ? SizedBox(
              width: kToolbarHeight,
              height: kToolbarHeight,
              child: Material(
                borderRadius: BorderRadius.zero,
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(true),
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
      elevation: 5.0,
      automaticallyImplyLeading: canBack,
      title: title != null
          ? Text(
              title!,
              style: const TextStyle(
                color: whiteTextColor,
                fontSize: AppFonts.h1FontSize,
                fontWeight: FontWeight.w500,
              ),
            )
          : const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Student',
                  style: TextStyle(
                    color: whiteTextColor,
                    fontSize: AppFonts.h1FontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Hub',
                  style: TextStyle(
                    color: blackTextColor,
                    fontSize: AppFonts.h1FontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
      actions: isShowIcon
          ? [
              IconButton(
                onPressed: handlePressIcon,
                icon: const Icon(
                  Icons.person,
                  size: 26,
                  color: whiteTextColor,
                ),
              ),
            ]
          : [],
    );
  }
}
