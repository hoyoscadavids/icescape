import 'package:flutter/material.dart';
import 'package:icescape_mosy_2019/widgets/hexagonal_button.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final double HEXAGON_BUTTON_SIZE = 100;
final double HEXAGON_SIZE = HEXAGON_BUTTON_SIZE * 0.15;

class _HomePageState extends State<HomePage> {
  List<List<bool>> PRESSED_BUTTONS_MATRIX = List<List<bool>>();
  final int ROW_COUNT = 5, COLUMN_COUNT = 10;

  // The extra index in field is used because the field is not divided as a matrix
  // but instead a one dimensional array
  int indexRow = 0, indexColumn = 0, indexInField = 0;
  bool reversedColumn = false;
  Widget _buildHexagonButton(int numberOfHexagonsInRow) {
    if(!reversedColumn){
      indexInField++;
    }
    else{
      indexInField--;
    }
    if(!((indexRow == numberOfHexagonsInRow - 1 && indexColumn == 3) ||
        (indexRow == 0 && indexColumn == 6)
        //|| (indexRow == 0 && indexColumn == 0)
    )
    ){
    return Container(
      key: Key((indexInField).toString()),
      height: HEXAGON_BUTTON_SIZE,
      width: HEXAGON_BUTTON_SIZE,
      child: HexagonalButton(
        color: Colors.black,
        size: HEXAGON_SIZE,
        onPressed: () {

        },
      ),
    );
    }
    else {
      return SizedBox(height: HEXAGON_BUTTON_SIZE + 4,);
    }
  }
  List<Widget> _buildHexagonButtonColumn(int numberOfHexagonsInRow) {
    List<Widget> hexagonColumn = List<Widget>();
    for (int i = 0; i < numberOfHexagonsInRow; i++) {
        hexagonColumn.add(_buildHexagonButton(numberOfHexagonsInRow));
        hexagonColumn.add(SizedBox(
          height: 4.0,
        ));
      indexRow++;
    }
    indexRow = 0;
    return hexagonColumn;
  }

  List<Widget> _buildGrid(int numberOfColumns, screenLength) {
    List<Widget> columns = List<Widget>();
    double offset = 0;
    for (int i = 0; i < numberOfColumns; i++) {
      offset = i % 2 == 0 ? 0 : HEXAGON_BUTTON_SIZE;
      columns.add(Column(
        children: <Widget>[SizedBox(height: offset + screenLength/(numberOfColumns*20),)]..addAll(_buildHexagonButtonColumn(ROW_COUNT)),
      ));
      reversedColumn = !reversedColumn;
      reversedColumn ? indexInField += ROW_COUNT + 1 : indexInField += ROW_COUNT - 1;
      indexColumn ++;
    }
    indexColumn = 0;
    indexInField = 0;
    return columns;
  }

  @override
  void initState() {
    super.initState();
    for(int i = 0; i < ROW_COUNT; i++){
      List<bool> temp = List<bool>(COLUMN_COUNT);
      for(int j = 0; j < COLUMN_COUNT; j++){
        temp[j] = false;
      }
      PRESSED_BUTTONS_MATRIX.add(temp);
      reversedColumn = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    final SCREEN_LENGTH = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 76),
        child: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(right: 24.0),
            child: IconButton(
                icon: Icon(
                  Icons.menu,
                  size: 40,
                ),
                onPressed: null),
          ),
          title: Text(
            "Icescape",
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 24),
            child: SingleChildScrollView(
              child: Row(
                children: <Widget>[]..addAll(_buildGrid(COLUMN_COUNT, SCREEN_LENGTH)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
