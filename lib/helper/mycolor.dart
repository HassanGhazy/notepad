import 'package:flutter/material.dart';

class MyColor {
  MyColor._();
  static MyColor colors = MyColor._();

  static const Color appBarColor = const Color(0xff937654);
  static const Color backgroundScaffold = const Color(0xffFFFFDD);
  static const Color blackcolor = const Color(0xff000000);
  static const Color textColor = const Color(0xff7D7159);
  static const Color middleLineDrawer = const Color(0xffEDEDCB);

  static BoxDecoration containerDercoration = BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    border: Border.all(
      color: appBarColor,
    ),
    gradient: containerColorWithoutSelected,
  );
  static const LinearGradient containerColorWithoutSelected =
      const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFAFCCD),
      Color(0xFFFEFBCE),
    ],
  );
  static const LinearGradient containerColorWithSelected = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFBF6D6),
      Color(0xFFBB9E80),
    ],
  );
}
