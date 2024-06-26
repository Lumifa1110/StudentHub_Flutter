import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final IconData icon;
  final double radius;
  final Color backgroundColor;
  final Color iconColor;

  const UserAvatar({
    super.key,
    required this.icon,
    this.radius = 24.0,
    this.backgroundColor = Colors.blue,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: Icon(
        icon,
        size: radius * 1, // Adjust the icon size as needed
        color: iconColor,
      ),
    );
  }
}
