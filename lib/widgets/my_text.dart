import 'package:flutter/material.dart';
import 'package:notepad/helper/mycolor.dart';

class MyText extends StatelessWidget {
  MyText(this.text);
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 15, color: MyColor.blackcolor),
    );
  }
}
