import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final String text;
  final Color textColor;
  final double size;

  const PrimaryButton(
      {Key key,
      this.onPressed,
      this.color = Colors.lightBlue,
      this.text,
      this.textColor = Colors.white,
      this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      child: RaisedButton(
        onPressed: onPressed,
        color: color,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(10)),
        disabledColor: Colors.black26,
      ),
    );
  }
}
