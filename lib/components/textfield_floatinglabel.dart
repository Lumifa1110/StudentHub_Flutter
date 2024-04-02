import 'package:flutter/material.dart';
import 'package:studenthub/utils/colors.dart';

class TextFieldFloatingLabel extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool isPassword;

  const TextFieldFloatingLabel({
    Key? key,
    required this.label,
    required this.controller,
    this.isPassword = false,
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
              color: const Color(0xFF636363).withOpacity(0.5),
              spreadRadius: 3.0,
              blurRadius: 6.0,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextField(
          controller: widget.controller,
          style: const TextStyle(
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
            contentPadding:
                const EdgeInsets.symmetric(vertical: 6, horizontal: 1),
            floatingLabelStyle: const TextStyle(
              color: mainColor,
              fontSize: 18,
              height: 0.6,
              fontWeight: FontWeight.bold,
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: mainColor,
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
