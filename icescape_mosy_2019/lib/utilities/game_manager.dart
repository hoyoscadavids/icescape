
class GameManager{
  String _tileString;
  List<int> tileList;

  String get tileString => _tileString;


  void setTiles(List<int> tiles){
    tileList = tiles;
    tiles.map((tile){
      _tileString += (tile.toString() + ", ");
    });
  }

  bool checkMove(int position){
    return tileList[position] == 1;
  }


}