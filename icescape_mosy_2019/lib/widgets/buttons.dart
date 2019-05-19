import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final String text;
  final Color textColor;

  const PrimaryButton(
      {Key key,
      this.onPressed,
      this.color = Colors.lightBlue,
      this.text,
      this.textColor = Colors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlatButton(
        onPressed: onPressed,
        color: color,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        disabledColor: Colors.black26,
      ),
    );
  }
}
