import 'package:flutter/material.dart';
import 'package:studenthub/utils/colors.dart';
import 'package:studenthub/utils/font.dart';

class TextFieldFloatingLabel extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;
  final String? hint;

  const TextFieldFloatingLabel({
    Key? key,
    required this.label,
    required this.controller,
    this.isPassword = false,
    this.hint,
  }) : super(key: key);

  @override
  State<TextFieldFloatingLabel> createState() => _TextFieldFloatingLabelState();
}

class _TextFieldFloatingLabelState extends State<TextFieldFloatingLabel> {
  late bool _isObscure;

  @override
  void initState() {
    _isObscure = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(9),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.shadow.withOpacity(0.8),
              spreadRadius: 3.0,
              blurRadius: 3.0,
            ),
          ],
        ),
        child: TextField(
          controller: widget.controller,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 18,
          ),
          cursorColor: blackTextColor,
          obscureText: _isObscure,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surface,
            labelText: widget.label,
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 18,
            ),
            hintText: widget.hint,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: 18,
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 1),
            floatingLabelStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: AppFonts.h1_2FontSize,
              height: 0.6,
              fontWeight: FontWeight.bold,
            ),
            enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: BorderSide(
                color: widget.controller.text.isNotEmpty
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
                width: 2.6,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.circular(9),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 2.6,
              ),
            ),
            focusColor: blackTextColor,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
