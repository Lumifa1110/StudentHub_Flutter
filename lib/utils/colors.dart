import 'package:flutter/material.dart';

const Color bgColor = Color(0xFFF3F3F3);
const Color darkbgColor = Color(0xFF636363);

const Color mainColor = Color(0xFF0F90F0);

const Color whiteTextColor = Color(0xFFFFFFFF);

const Color blackTextColor = Color(0xFF424242);

const Color darkgrayColor = Color(0xFF424242);
const Color lightgrayColor = Color(0xFF636363);
const Color lightergrayColor = Color(0xFFA9A9A9);
const Color lightestgrayColor = Color(0xFFD4D4D4);

const Color darkblueColor = Color(0xFF085394);

const Color errorColor = Color(0xFFC40606);

class AppColor {
  static const primary = Color(0xFF0F90F0);
  static const secondary = Color(0xFF1E6AE1);
  static const tertiary = Color(0xFF1AC281);
  static const background = Color(0xFFF9F8FE);
  static const textFieldBackground = Color(0xFFEBEBEB);
}
 Color statusFlagColors(int status){
    if(status == 0){
      return Colors.grey;
    }
    if(status == 1){
      return Colors.green;
    }    if(status == 2){
      return Colors.orange;
    }
    return Colors.blue;
 }