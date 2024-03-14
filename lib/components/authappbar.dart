import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:studenthub/utils/colors.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 5.0,
      automaticallyImplyLeading: false,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Color(0xFF4169E1),
      ),
      backgroundColor: mainColor,
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
