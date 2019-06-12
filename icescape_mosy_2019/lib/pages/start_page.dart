import 'package:flutter/material.dart';
import 'package:icescape_mosy_2019/widgets/buttons.dart';
import 'package:icescape_mosy_2019/pages/game_page.dart';
import 'package:icescape_mosy_2019/utilities/bluetooth_manager.dart';
import "package:flare_flutter/flare_actor.dart";

class StartPage extends StatefulWidget {
  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final BluetoothManager manager = BluetoothManager();
  bool isConnected =
      true; // TODO: Make the connect bluetooth appear as unavailable when already connected and start the other way around
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    final double divider = 5;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Icescape",
          textAlign: TextAlign.center,
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            width: width,
            child: FlareActor("assets/bear.flr",
                alignment: Alignment.center,
                fit: BoxFit.cover,
                animation: "idle"),
          ),
          Padding(
            padding: EdgeInsets.only(left: width / divider, right: width / divider, bottom: height /divider *0.5, top: height / divider*3),
            child: Center(
              child: Material(
                color: Colors.black26,
                child: Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      PrimaryButton(
                        text: "Start Game",
                        onPressed: isConnected
                            ? () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GamePage(
                                          bluetoothManager: manager,
                                        ),
                                  ),
                                )
                            : null,
                      ),
                      PrimaryButton(
                          text: "Connect",
                          onPressed: () {
                            manager.initialize().then((_) {
                              manager.scanAndConnect().then((_) {
                                setState(() {
                                  //isConnected = manager.isConnected; // TODO: Finish functionality
                                });
                              });
                            }); // Initializes bluetooth and connects to Arduino
                          }),
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
