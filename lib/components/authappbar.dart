import 'package:flutter/material.dart';
import 'package:studenthub/screens/index.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool canBack;
  final String? title;

  const AuthAppBar({
    super.key, 
    required this.canBack,
    this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leadingWidth: 24,
      centerTitle: false,
      leading: canBack
          ? IconButton(
              icon: const Icon(Icons.chevron_left, color: whiteTextColor),
              onPressed: () => Navigator.of(context).pop(),
              color: Colors.white
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
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Hub',
                  style: TextStyle(
                    color: blackTextColor,
                    fontSize: AppFonts.h1FontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SwitchScreen()));
          },
          icon: const Icon(
            Icons.person,
            size: 26,
            color: Colors.white,
          ),
        )
      ],
    );
  }
}
