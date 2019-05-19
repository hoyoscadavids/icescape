import 'package:flutter/material.dart';

ThemeData mainTheme() {
  return ThemeData(
      primarySwatch: Colors.lightBlue,
      primaryTextTheme:
          TextTheme(title: TextStyle(fontFamily: "Roboto", color: Colors.white,)),
  );

}
