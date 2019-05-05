import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:polygon_clipper/polygon_border.dart';

class HexagonalButton extends StatelessWidget {
  final Function onPressed;
  final Color color;
  final double size;
  final Key key;
  HexagonalButton({this.onPressed, this.color, this.size, this.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: this.size,
      width: this.size,
      child: MaterialButton(
        key: this.key,
        shape: PolygonBorder(
          borderRadius: -this.size,
          sides: 6,
          rotate: 30,
        ),
        color: this.color,
        onPressed: this.onPressed,
      ),
    );
  }
}

