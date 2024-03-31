import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final IconData icon;
  final double radius;
  final Color backgroundColor;
  final Color iconColor;

  const UserAvatar({
    super.key,
    required this.icon,
    this.radius = 20.0,
    this.backgroundColor = Colors.blue,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      child: Icon(
        icon,
        size: radius * 1, // Adjust the icon size as needed
        color: iconColor,
      ),
    );
  }
}
