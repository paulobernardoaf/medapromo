import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as prefix0;

class Colors {

  const Colors();

  static  Color loginGradientStart = prefix0.Colors.redAccent;
  static Color loginGradientEnd = Color(0xFFfbab66);

  static final primaryGradient = LinearGradient(
    colors: [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

}