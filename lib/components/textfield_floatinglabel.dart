import 'package:flutter/material.dart';
import 'package:studenthub/utils/colors.dart';

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
    // TODO: implement initState
    _isObscure = widget.isPassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.5),
              spreadRadius: 3.0,
              blurRadius: 6.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: widget.controller,
          style: const TextStyle(
            color: blackTextColor,
            fontSize: 18,
          ),
          cursorColor: blackTextColor,
          obscureText: _isObscure,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: whiteTextColor,
            labelText: widget.label,
            labelStyle: const TextStyle(
              color: darkgrayColor,
            ),
            hintText: widget.hint,
            contentPadding: const EdgeInsets.symmetric(vertical: 6, horizontal: 1),
            floatingLabelStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 18,
              height: 0.6,
              fontWeight: FontWeight.bold,
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 3.0,
              ),
            ),
            focusColor: blackTextColor,
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                      color: blackTextColor,
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
