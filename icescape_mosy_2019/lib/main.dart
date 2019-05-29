import 'package:flutter/material.dart';
import 'package:icescape_mosy_2019/pages/game_page.dart';
import 'package:icescape_mosy_2019/themes/main_theme.dart';
import 'package:icescape_mosy_2019/pages/start_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: mainTheme(),
      home: StartPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
 @override
  Widget build(BuildContext context) {
    return GamePage();
  }
}
