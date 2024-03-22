import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studenthub/utils/colors.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool canBack;
  final String? title; // Remove const here

  const AuthAppBar({
    Key? key, // Add Key? key here
    required this.canBack,
    this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 5.0,
      automaticallyImplyLeading: canBack,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF4169E1),
      ),
      backgroundColor: mainColor,
      title: title != null
          ? Text(title!)
          : Row(
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
          onPressed: () {},
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
