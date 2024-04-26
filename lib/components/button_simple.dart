import 'package:flutter/material.dart';

class ButtonSimple extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isButtonEnabled;

  const ButtonSimple({
    super.key,
    required this.label,
    required this.onPressed,
    required this.isButtonEnabled
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isButtonEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: isButtonEnabled ? Colors.blue : Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center, // Center the text
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isButtonEnabled ? Colors.white : Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.bold
        )
      ),
    );
  }
}