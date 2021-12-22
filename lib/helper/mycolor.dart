import 'package:flutter/material.dart';
import 'package:notepad/helper/shared_preference_helper.dart';

class MyColor {
  MyColor._();
  static MyColor colors = MyColor._();

  // static const Color blackcolor = const Color(0xff000000);
  // static const Color middleLineDrawer = const Color(0xffEDEDCB);
  // static const Color backgroundToast = const Color(0xff666666);

  // static BoxDecoration containerDercoration = BoxDecoration(
  //   borderRadius: const BorderRadius.all(Radius.circular(10)),
  //   border: Border.all(
  //       // color: appBarColor,
  //       ),
  //   gradient: LinearGradient(
  //     begin: Alignment.topCenter,
  //     end: Alignment.bottomCenter,
  //     colors: <Color>[
  //       MyColor.linear1WithoutSelected,
  //       MyColor.linear1WithoutSelected,
  //     ],
  //   ),
  // );
  static Color topDrawer = const Color(0xff927855);
  static Color backgroundDrawer = const Color(0xffFFFFDD);
  static Color linear1Selected = Colors.white;
  static Color linear2Selected = Colors.white;
  static Color linear1WithoutSelected = Colors.white;
  static Color linear2WithoutSelected = Colors.white;
  static void getColor() {
    String? val =
        SharedPreferenceHelper.sharedPreference.getStringData('theme');

    switch (val) {
      case "0": // light
        linear1Selected = const Color(0xffF3F3F3);
        linear2Selected = const Color(0xffC1C1C1);
        linear1WithoutSelected = const Color(0xffFAFAFA);
        linear2WithoutSelected = const Color(0xffFBFBFB);
        topDrawer = const Color(0xffB6B6B6);
        backgroundDrawer = const Color(0xffFFFFFF);
        break;
      case "1": // dark
        linear1Selected = const Color(0xff242721);
        linear2Selected = const Color(0xff82946E);
        linear1WithoutSelected = const Color(0xff131313);
        linear2WithoutSelected = const Color(0xff121212);
        topDrawer = const Color(0xff353634);
        backgroundDrawer = const Color(0xff131313);
        break;
      case "2": // system
        linear1Selected = const Color(0xffFBF6D6);
        linear2Selected = const Color(0xffBB9E80);
        linear1WithoutSelected = const Color(0xFFFAFCCD);
        linear2WithoutSelected = const Color(0xFFFEFBCE);
        topDrawer = const Color(0xff927855);
        backgroundDrawer = const Color(0xffFFFFDD);
        break;
      default:
        linear1Selected = const Color(0xff242721);
        linear2Selected = const Color(0xff82946E);
        linear1WithoutSelected = const Color(0xff131313);
        linear2WithoutSelected = const Color(0xff121212);
        backgroundDrawer = const Color(0xff131313);
        topDrawer = const Color(0xff353634);
    }
    // print(linear1WithoutSelected);
  }

  // static LinearGradient containerColorWithoutSelected = LinearGradient(
  //   begin: Alignment.topCenter,
  //   end: Alignment.bottomCenter,
  //   colors: <Color>[
  //     MyColor.linear1WithoutSelected,
  //     MyColor.linear1WithoutSelected,
  //   ],
  // );
  // static LinearGradient containerColorWithSelected = LinearGradient(
  //   begin: Alignment.topCenter,
  //   end: Alignment.bottomCenter,
  //   colors: <Color>[
  //     MyColor.linear1Selected,
  //     MyColor.linear2Selected,
  //   ],
  // );
}
