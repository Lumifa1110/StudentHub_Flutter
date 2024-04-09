import 'package:flutter/material.dart';
import 'package:studenthub/enums/user_role.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class CardSwitchAccount extends StatelessWidget {
  final IconData accountAvt;
  final String accountFullname;
  final String accountRole;
  final bool isSelected;
  final VoidCallback onTap;
  const CardSwitchAccount({
    super.key,
    required this.accountAvt,
    required this.accountFullname,
    required this.accountRole,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: ListTile(
        tileColor: isSelected ? Colors.green : null,
        dense: true,
        leading: Icon(
          accountAvt,
          size: 36,
        ),
        title: Text(
          accountFullname,
          style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: AppFonts.h2FontSize,
              fontWeight: FontWeight.w500,
              color: isSelected ? whiteTextColor : blackTextColor),
        ),
        subtitle: Text(
          accountRole == '0' ? 'Student' : 'Company',
          style: TextStyle(
              fontSize: AppFonts.h3FontSize,
              color: isSelected ? whiteTextColor : blackTextColor),
        ),
      ),
    );
  }
}
