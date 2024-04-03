import 'package:flutter/material.dart';
import 'package:studenthub/utils/font.dart';

class CardSwitchAccount extends StatelessWidget {
  final IconData accountAvt;
  final String accountName;
  final String accountRole;
  const CardSwitchAccount({
    Key? key,
    required this.accountAvt,
    required this.accountName,
    required this.accountRole,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ListTile(
        dense: true,
        leading: Icon(
          accountAvt,
          size: 40,
        ),
        title: Text(
          accountName,
          style: const TextStyle(
            overflow: TextOverflow.ellipsis,
            fontSize: AppFonts.h1FontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          accountRole,
          style: const TextStyle(fontSize: AppFonts.h3FontSize),
        ),
      ),
    );
  }
}
