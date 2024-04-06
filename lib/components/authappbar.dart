import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studenthub/utils/colors.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool canBack;
  final String? title;
  final IconData? icon;
  final VoidCallback? onTapIcon;

  const AuthAppBar({
    Key? key, // Add Key? key here
    required this.canBack,
    this.title,
    this.icon, // Thêm icon vào
    this.onTapIcon,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
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
          onPressed: onTapIcon,
          icon: icon != null
              ? Icon(
                  icon,
                  size: 26,
                  color: blackTextColor,
                )
              : const Icon(
                  Icons.person,
                  size: 26,
                  color: blackTextColor,
                ),
        )
      ],
    );
  }
}
