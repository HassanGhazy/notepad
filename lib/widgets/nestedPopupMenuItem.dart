import 'package:flutter/material.dart';
import 'package:notepad/helper/luncher_helper.dart';
import 'package:easy_localization/easy_localization.dart';

class NestedPopupMenuItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Share").tr(),
          Icon(
            Icons.arrow_forward,
            color: Colors.black,
          ),
        ],
      ),
      itemBuilder: (BuildContext bc) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("By Email").tr(),
                const Icon(
                  Icons.email,
                  color: Colors.black,
                ),
              ],
            ),
            value: 0),
        PopupMenuItem<int>(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("By Telegram").tr(),
                const Icon(
                  Icons.near_me,
                  color: Colors.black,
                ),
              ],
            ),
            value: 1),
        PopupMenuItem<int>(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text("By SMS").tr(),
                const Icon(
                  Icons.sms,
                  color: Colors.black,
                ),
              ],
            ),
            value: 2),
      ],
      onSelected: (int value) {
        switch (value) {
          case 0:
            LauncherHelper.launcher.sendEmail();
            break;
          case 1:
            LauncherHelper.launcher.sendTel();

            break;
          case 2:
            LauncherHelper.launcher.sendSms();
            break;
          default:
        }
      },
    );
  }
}
