import 'package:flutter/material.dart';

class MyColor {
  MyColor._();
  static MyColor colors = MyColor._();

  static const Color appBarColor = Color(0xff937654);
  static const Color backgroundScaffold = Color(0xffFFFFDD);
  static const Color blackcolor = Color(0xff000000);
  static const Color textColor = Color(0xff7D7159);
  static const Color middleLineDrawer = Color(0xffEDEDCB);
  static const Color backgroundToast = Color(0xff666666);
  static const Color white = Color(0xffffffff);
  static const Color material = Color(0xff283136);
  static const Color switchColor = Color(0xff7A6D4B);

  static BoxDecoration containerDercoration = BoxDecoration(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    border: Border.all(
      color: appBarColor,
    ),
    gradient: containerColorWithoutSelected,
  );
  static const LinearGradient containerColorWithoutSelected = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFFFAFCCD),
      Color(0xFFFEFBCE),
    ],
  );
  static const LinearGradient containerColorWithSelected = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      Color(0xFFFBF6D6),
      Color(0xFFBB9E80),
    ],
  );
}
