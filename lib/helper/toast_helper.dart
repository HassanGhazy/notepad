import 'package:fluttertoast/fluttertoast.dart';
// import '../helper/mycolor.dart';
import 'package:easy_localization/easy_localization.dart';

class ToastHelper {
  ToastHelper._();

  static Future<bool?> flutterToast(String msg) {
    return Fluttertoast.showToast(
        msg: msg.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        // backgroundColor: MyColor.backgroundToast,
        // textColor: MyColor.white,
        fontSize: 16.0);
  }
}
