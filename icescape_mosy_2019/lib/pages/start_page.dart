import 'package:flutter/material.dart';
import 'package:icescape_mosy_2019/widgets/buttons.dart';
import 'package:icescape_mosy_2019/pages/game_page.dart';
import 'package:icescape_mosy_2019/utilities/bluetooth_manager.dart';
import "package:flare_flutter/flare_actor.dart";
import 'package:flutter/services.dart';

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final BluetoothManager manager = BluetoothManager();
  bool isConnected = false;
  @override
  void initState() {
    super.initState();
    SystemChrome
        .setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double divider = 6;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            width: width,
            child: FlareActor("assets/bear.flr",
                alignment: Alignment.center,
                fit: BoxFit.cover,
                animation: "idle"),
          ),
          Align(
              alignment: Alignment(0, 0.5),
              child: Container(
                  width: 300,
                  child: Image(
                    image: AssetImage("assets/Icescape.png"),
                    fit: BoxFit.fill,
                  ))),
          Padding(
            padding: EdgeInsets.only(
                left: width / divider,
                right: width / divider,
                top: height / divider * 4.5),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[

                      PrimaryButton(
                        text: "Start Game",
                        onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GamePage(
                                      bluetoothManager: manager,
                                    ),
                              ),
                            ),
                      ),
                      PrimaryButton(
                          text: "Connect",
                          onPressed: !isConnected
                              ? () {
                                  manager.initialize().then((_) {
                                    manager.scanAndConnect().then((_) {
                                      setState(() {
                                        isConnected = true;
                                      });
                                      Future.delayed(Duration(milliseconds: 5000),
                                          () {
                                        if (manager.isConnected) {
                                          setState(() {
                                            isConnected = true;
                                          });
                                          buildConnectionDialog(true, context);
                                        } else {
                                          setState(() {
                                            isConnected = false;
                                          });
                                          buildConnectionDialog(false, context);
                                        }
                                      });
                                    });
                                  }); // Initializes bluetooth and connects to Arduino
                                }
                              : null),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void buildConnectionDialog(bool connected, BuildContext context) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Connection State"),
          content:
              Text(connected ? "Connection Successful" : "Connection Failed"),
          actions: <Widget>[
            FlatButton(
              child: Text("Ok"),
              onPressed: () => Navigator.pop(context),
            )
          ],
        );
      });
}
