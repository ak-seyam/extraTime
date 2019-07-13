import 'package:extratime/constants.dart';
import 'package:flutter/material.dart';
import 'extra_time_widgets.dart';

const PRIMARY_COLOR = Color(0xFF92d050);
const PRIMARY_COLOR_TEXT = Color(0xFF1f2617);
const BACKGROUND = Colors.white;

main() => runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      buttonColor: PRIMARY_COLOR_2,
        primaryColor: PRIMARY_COLOR,
        cursorColor: PRIMARY_COLOR,
        appBarTheme: AppBarTheme(color: BACKGROUND),
        backgroundColor: BACKGROUND),
    home: LoginPage()));
