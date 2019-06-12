import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:icescape_mosy_2019/widgets/hexagonal_button.dart';
import 'package:icescape_mosy_2019/utilities/bluetooth_manager.dart';
import 'package:icescape_mosy_2019/widgets/buttons.dart';

class GamePage extends StatefulWidget {
  final BluetoothManager bluetoothManager;

  const GamePage({Key key, this.bluetoothManager}) : super(key: key);
  @override
  _GamePageState createState() => _GamePageState();
}

final double hexagonButtonSize = 30; // 100 for tablet
final double hexagonSize = hexagonButtonSize * 0.15;

class _GamePageState extends State<GamePage> {
  static final int rowCount = 5, columnCount = 10;
  List<List<bool>> pressedButtonsMatrix = List<List<bool>>.generate(columnCount,
      (buttonRow) => List<bool>.generate(rowCount, (button) => false));

  // The extra index in field is used because the field is not divided as a matrix
  // but instead a one dimensional array
  int indexRow = 0, indexColumn = 0, indexInField = 0;
  bool reversedColumn = false;
  bool gameStarted = false;

  void _onStart() {
    if (!gameStarted) {
      _sendMatrix();
    }
    gameStarted = !gameStarted;
  }

  void _sendMatrix() {
    // Sends the Matrix to the Arduino Bluetooth with the following Format:
    // 0+0000000000000000-
    // This protocol sends three Strings, each containing 16 values from the matrix between the + and -.
    // The first number indicates which part of the Matrix it is (0 - 2).
    // The reason to separate it in three Strings is because of the limited
    // String length that the HM - 10 Bluetooth module provides.

    List<String> sendStrings = List<String>.generate(3, (sendString) => "");
    indexRow = 0;
    indexColumn = 0;
    int reversedColumnIndex = 0;
    for (int i = 0; i < 3; i++) {
      sendStrings[i] += i.toString() + "+";
      for (int j = 0; j < 16; j++) {
        if (indexColumn >= rowCount) {
          reversedColumn = !reversedColumn;
          reversedColumnIndex = reversedColumn ? rowCount - 1 : 0;
          indexColumn = 0;
          indexRow++;
        }
        if (!(indexColumn == 0 && indexRow == 3 ||
            indexColumn == 0 && indexRow == 6)) {
          sendStrings[i] +=
              pressedButtonsMatrix[indexRow][reversedColumnIndex] ? "1" : "0";
        } else
          j--;
        indexColumn++;
        if (reversedColumn)
          reversedColumnIndex--;
        else
          reversedColumnIndex++;
      }

      sendStrings[i] += "-";
      Future.delayed(Duration(milliseconds: 200 * (i + 1)), () {
        widget.bluetoothManager.write(sendStrings[i]);
      });
    }
    reversedColumn = false;
  }

  void _onReset() {
    setState(() {
      pressedButtonsMatrix.map((buttons) {
        buttons.map((button) {
          setState(() {
            button = false;
          });
        });
      });
    });
  }

  // Builds the hexagon fields
  Widget _buildHexagonButton(
      int numberOfHexagonsInRow, int indexRow, int indexColumn) {
    if (!reversedColumn) {
      indexInField++;
    } else {
      indexInField--;
    }
    if (!((indexRow == numberOfHexagonsInRow - 1 && indexColumn == 3) ||
            (indexRow == 0 && indexColumn == 6)
        //|| (indexRow == 0 && indexColumn == 0)
        )) {
      // The Hexagons buttons have each a bool value assign to them. These values
      // are saved in a Matrix.
      return Container(
        key: Key(indexRow.toString() +
            indexColumn.toString()), // Unique Identifier in form XX
        height: hexagonButtonSize,
        width: hexagonButtonSize,
        child: HexagonalButton(
          color: pressedButtonsMatrix[indexColumn][indexRow]
              ? Colors.white
              : Colors.lightBlue,
          size: hexagonSize,
          onPressed: () {
            setState(() {
              pressedButtonsMatrix[indexColumn][indexRow] =
                  !pressedButtonsMatrix[indexColumn][indexRow];
            });
          },
        ),
      );
    } else {
      return SizedBox(
        height: hexagonButtonSize + 4,
      );
    }
  }

  // Builds a column of hexagons
  List<Widget> _buildHexagonButtonColumn(
      int numberOfHexagonsInRow, int indexColumn) {
    List<Widget> hexagonColumn = List<Widget>();
    for (int i = 0; i < numberOfHexagonsInRow; i++) {
      hexagonColumn
          .add(_buildHexagonButton(numberOfHexagonsInRow, i, indexColumn));
      hexagonColumn.add(SizedBox(
        height: 4.0,
      ));
      indexRow++;
    }
    indexRow = 0;
    return hexagonColumn;
  }

  // Builds the whole grid of hexagons. Take into account that because of the LED
  // strip, and the way it is physically built, every other Column has to be built
  // reversed (From bottom to top)
  List<Widget> _buildGrid(int numberOfColumns, screenLength) {
    List<Widget> columns = List<Widget>();
    double offset = 0;
    for (int i = 0; i < numberOfColumns; i++) {
      offset = i % 2 == 0 ? 0 : hexagonButtonSize;
      columns.add(Column(
        children: <Widget>[
          SizedBox(
            height: offset + screenLength / (numberOfColumns * 20),
          )
        ]..addAll(_buildHexagonButtonColumn(rowCount, i)),
      ));
      reversedColumn = !reversedColumn;
      reversedColumn
          ? indexInField += rowCount + 1
          : indexInField += rowCount - 1;
      indexColumn++;
    }
    indexColumn = 0;
    indexInField = 0;
    return columns;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final widthDivider = 12;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          "Icescape",
          textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(
                width / widthDivider, 0, width / widthDivider, 0),
            child: SingleChildScrollView(
              child: Row(
                children: <Widget>[]..addAll(_buildGrid(columnCount, width)),
              ),
            ),
          ),
        ]..add(
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  PrimaryButton(
                    text: "Reset",
                    onPressed: null//_onReset,
                  ),
                  PrimaryButton(
                    text: "Start",
                    onPressed: _onStart,
                  ),
                ],
              ),
            ),
          ),
      ),
    );
  }
}
