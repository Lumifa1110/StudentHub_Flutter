import 'package:flutter/material.dart';
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
      onTap: onTap,
      child: ListTile(
        tileColor: isSelected ? Theme.of(context).colorScheme.primary : Colors.white,
        dense: true,
        leading: Icon(
          accountAvt,
          size: 36,
          color: isSelected ? Colors.white : Colors.black54,
        ),
        title: Text(
          accountFullname,
          style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: AppFonts.h2FontSize,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.black54),
        ),
        subtitle: Text(
          accountRole == '0'
              ? 'Student'
              : accountRole == '1'
                  ? 'Company'
                  : 'Account',
          style: TextStyle(
              fontSize: AppFonts.h3FontSize, color: isSelected ? Colors.white : Colors.black54),
        ),
      ),
    );
  }
}
