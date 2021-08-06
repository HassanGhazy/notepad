import 'package:fluttertoast/fluttertoast.dart';
import 'package:notepad/helper/mycolor.dart';

class ToastHelper {
  ToastHelper._();

  static Future<bool?> flutterToast(String msg) {
    return Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: MyColor.backgroundToast,
        textColor: MyColor.white,
        fontSize: 16.0);
  }
}
