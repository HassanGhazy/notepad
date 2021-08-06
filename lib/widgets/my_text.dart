import 'package:flutter/material.dart';
import '../helper/mycolor.dart';

class MyText extends StatelessWidget {
  const MyText(this.text);
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text!,
      style: const TextStyle(
          fontWeight: FontWeight.bold, fontSize: 15, color: MyColor.blackcolor),
    );
  }
}
