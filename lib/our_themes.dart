import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class CustomThemes {
  static final lightTheme = ThemeData(
    cardColor: Colors.white,
    // fontFamily: "poppins",
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Vx.gray800,
    iconTheme: const IconThemeData(
      color: Vx.gray600,
    ),
  );
  static final darkTheme = ThemeData(
    cardColor: bgColor.withOpacity(0.6),
    // fontFamily: "poppins",
    scaffoldBackgroundColor: bgColor,
    primaryColor: Colors.white,
    iconTheme: const IconThemeData(color: Colors.white),
  );
}

const bgColor = Color(0xff202125);
const cardColor = Color(0xff57A0ED);
const dividerColor = Vx.gray200;
const textColor = Vx.gray800;
// const p = Vx.amber100;