import 'package:flutter/material.dart';
import '../helper/mycolor.dart';

class ProviderNote with ChangeNotifier {
  ThemeData _themeData;
  ProviderNote(this._themeData);
  getTheme() => _themeData;

  setTheme(ThemeData themeData) async {
    _themeData = themeData;
    MyColor.getColor();
    notifyListeners();
  }
}
