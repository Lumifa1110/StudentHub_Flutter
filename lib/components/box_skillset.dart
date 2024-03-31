import 'package:flutter/material.dart';

class BoxSkillset extends StatelessWidget {
  final String text;
  final VoidCallback onDelete;

  const BoxSkillset({
    super.key,
    required this.text,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
        color: Colors.blue,
      ),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14
            )
          ),
          IconButton(
            icon: const Icon(Icons.close),
            color: Colors.white,
            iconSize: 16,
            onPressed: onDelete,
          ),
        ]
      )
    );
  }
}