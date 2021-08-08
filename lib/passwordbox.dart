import 'package:flutter/material.dart';
import 'textwidget.dart';

class Passwordbox extends StatelessWidget {
  final Function onChanged;
  final String hintText;
  final IconData icon;
  const Passwordbox({
    Key key,
    this.hintText,
    this.icon,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Textwidget(
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        decoration: InputDecoration(
            border: InputBorder.none,
            icon: Icon(
              icon,
              color: Color(0XFFB0BEC5),
            ),
            hintText: hintText),
      ),
    );
  }
}
