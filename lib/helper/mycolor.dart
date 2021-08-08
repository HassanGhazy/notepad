import 'package:flutter/material.dart';

class MyColor {
  MyColor._();
  static MyColor colors = MyColor._();

  static const Color blackcolor = const Color(0xff000000);
  static const Color middleLineDrawer = const Color(0xffEDEDCB);
  static const Color backgroundToast = const Color(0xff666666);
  static const Color white = const Color(0xffffffff);

  static Color appBarColor = const Color(0xff937654);
  static Color textappBarColor = const Color(0xffffffff);
  static Color backgroundScaffold = const Color(0xffFFFFDD);
  static Color textColor = const Color(0xff000000);
  static Color switchColor = const Color(0xff7A6D4B);
  static Color topDrawer = const Color(0xff927855);
  static Color backgroundDrawer = const Color(0xffFFFFDD);

  void appBarColorSet(Color c) => appBarColor = c;
  void backgroundScaffoldSet(Color c) => backgroundScaffold = c;
  void textColorSet(Color c) => textColor = c;
  void switchColorSet(Color c) => switchColor = c;
  void topDrawerSet(Color c) => topDrawer = c;
  void backgroundDrawerSet(Color c) => backgroundDrawer = c;
  void textappBarColorSet(Color c) => backgroundDrawer = c;

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
