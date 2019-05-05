import 'package:flutter/material.dart';

ThemeData mainTheme() {
  return ThemeData(
      primarySwatch: Colors.blue,
      primaryTextTheme:
          TextTheme(title: TextStyle(fontFamily: 'Arial', fontSize: 32, color: Colors.white,)),
  );

}
