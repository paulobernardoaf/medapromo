import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' as prefix0;

class Colors {

  const Colors();

  static const Color loginGradientStart = prefix0.Colors.grey;
  static const Color loginGradientEnd = prefix0.Colors.grey;

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}