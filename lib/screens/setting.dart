import 'package:flutter/material.dart';
import '../helper/luncher_helper.dart';
import '../helper/mycolor.dart';
import '../helper/shared_preference_helper.dart';
import '../widgets/my_drawer.dart';
import 'package:wakelock/wakelock.dart';
import 'package:easy_localization/easy_localization.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool _moveDeletedToTrash = true;
  bool _openTheLastCategory = true;
  bool _showNoteCategory = true;
  bool _showNotelistScreen = false;
  bool _showEditlistScreen = false;
  bool _showNoteKeyboard = false;
  bool _swapSaveAndUndoButton = false;
  bool _automaticallySaved = true;
  bool _droppingData = true;
  bool _readMode = false;
  bool _keepScreenOn = false;
  bool _drawLines = false;
  int _cursorPosition = 0; // 1 => first : 0 => last
  int _language = 1; // 1 => english : 0 => arabic

  @override
  void initState() {
    initalData();

    super.initState();
  }

  void initalData() {
    _moveDeletedToTrash = SharedPreferenceHelper.sharedPreference
            .getBoolData("moveDeletedToTrash") ??
        true;
    _showNoteCategory = SharedPreferenceHelper.sharedPreference
            .getBoolData("showNoteCategory") ??
        true;
    _showNoteKeyboard = SharedPreferenceHelper.sharedPreference
            .getBoolData("showNoteKeyboard") ??
        false;
    _swapSaveAndUndoButton = SharedPreferenceHelper.sharedPreference
            .getBoolData("swapSaveAndUndoButton") ??
        false;
    _automaticallySaved = SharedPreferenceHelper.sharedPreference
            .getBoolData("automaticallySaved") ??
        true;
    _droppingData =
        SharedPreferenceHelper.sharedPreference.getBoolData("droppingData") ??
            true;
    _readMode =
        SharedPreferenceHelper.sharedPreference.getBoolData("readMode") ??
            false;
    _keepScreenOn =
        SharedPreferenceHelper.sharedPreference.getBoolData("keepScreenOn") ??
            false;
    _drawLines =
        SharedPreferenceHelper.sharedPreference.getBoolData("drawLines") ??
            false;

    _cursorPosition =
        SharedPreferenceHelper.sharedPreference.getIntData("cursorPosition") ??
            0;
    _language =
        SharedPreferenceHelper.sharedPreference.getIntData("language") ?? 1;
  }

  @override
  Widget build(BuildContext context) {
    // The setting of note list screens
    List<ListTile> notelistScreen = [
      ListTile(
        title: const Text("Open the last chosen category").tr(),
        subtitle:
            const Text("Opens the last chosen category on app start").tr(),
        trailing: Switch(
            activeColor: MyColor.switchColor,
            value: _openTheLastCategory,
            onChanged: (bool value) async {
              _openTheLastCategory = value;
              await SharedPreferenceHelper.sharedPreference
                  .saveBoolData("openTheLastCategory", _openTheLastCategory);
              setState(() {});
            }),
        onTap: () async {
          _openTheLastCategory = !_openTheLastCategory;
          await SharedPreferenceHelper.sharedPreference
              .saveBoolData("openTheLastCategory", _openTheLastCategory);
          setState(() {});
        },
      ),
      ListTile(
        title: const Text("Show note categories").tr(),
        subtitle: const Text("Show categories for each note on the list").tr(),
        trailing: Switch(
            activeColor: MyColor.switchColor,
            value: _showNoteCategory,
            onChanged: (bool value) async {
              _showNoteCategory = value;
              await SharedPreferenceHelper.sharedPreference
                  .saveBoolData("showNoteCategory", _showNoteCategory);
              setState(() {});
            }),
        onTap: () async {
          _showNoteCategory = !_showNoteCategory;
          await SharedPreferenceHelper.sharedPreference
              .saveBoolData("showNoteCategory", _showNoteCategory);
          setState(() {});
        },
      ),
    ];

    List<ListTile> generalSetting = [
      ListTile(
        title: const Text("Theme").tr(),
        subtitle: const Text("Changes color theme of visible elements").tr(),
        onTap: () {
          changeTheme();
        },
      ),
      ListTile(
        title: const Text("Language").tr(),
        subtitle: const Text("Change the language of the app").tr(),
        onTap: () {
          alertPositionCursor(
              "Change the language".tr(), "English".tr(), "Arabic".tr(), 1);
        },
      ),
      ListTile(
        title: const Text("Note list").tr(),
        onTap: () {
          _showNotelistScreen = true;
          setState(() {});
        },
      ),
      ListTile(
        title: const Text("Note editing").tr(),
        onTap: () {
          _showEditlistScreen = true;
          setState(() {});
        },
      ),
      ListTile(
        title: const Text("Move deleted notes to 'Trash'").tr(),
        subtitle:
            const Text("Deleted notes will be stored in the 'Trash' folder")
                .tr(),
        trailing: Switch(
            activeColor: MyColor.switchColor,
            value: _moveDeletedToTrash,
            onChanged: (bool value) async {
              _moveDeletedToTrash = value;
              await SharedPreferenceHelper.sharedPreference
                  .saveBoolData("moveDeletedToTrash", _moveDeletedToTrash);
              setState(() {});
            }),
        onTap: () async {
          _moveDeletedToTrash = !_moveDeletedToTrash;
          await SharedPreferenceHelper.sharedPreference
              .saveBoolData("moveDeletedToTrash", _moveDeletedToTrash);
          setState(() {});
        },
      ),
      ListTile(
        title: const Text("Privacy setting").tr(),
        subtitle: Text("Opens the privacy policy document.").tr(),
        onTap: () {
          LauncherHelper.launcher.openWebPage(
              "https://docs.google.com/document/d/1Irv9J70PnafXkBnI-9E_XHMCI_3DfuEzqESLfgQ_DEY/edit?usp=sharing");
        },
      ),
    ];
    // The setting of edit note list screen
    List<ListTile> editListScreen = [
      ListTile(
        title: const Text("Show note keyboard").tr(),
        subtitle:
            const Text("show keyboard after entering the note screen").tr(),
        trailing: Switch(
            activeColor: MyColor.switchColor,
            value: _showNoteKeyboard,
            onChanged: (bool value) async {
              _showNoteKeyboard = value;
              await SharedPreferenceHelper.sharedPreference
                  .saveBoolData("showNoteKeyboard", _showNoteKeyboard);
              setState(() {});
            }),
        onTap: () async {
          _showNoteKeyboard = !_showNoteKeyboard;
          await SharedPreferenceHelper.sharedPreference
              .saveBoolData("showNoteKeyboard", _showNoteKeyboard);

          setState(() {});
        },
      ),
      ListTile(
        title: const Text("Cursor position in a note").tr(),
        subtitle: const Text(
                "Cursor position after opening a note with keyboard visible")
            .tr(),
        onTap: () {
          alertPositionCursor(
              "Cursor position in a note".tr(),
              "Cursor at the beginning of a note".tr(),
              "Cursor at the end of a note".tr(),
              0);
        },
      ),
      ListTile(
        title: const Text('Switch "Save" and "Undo" buttons').tr(),
        subtitle:
            const Text('Switches the "Save" and "Undo" buttons placement').tr(),
        trailing: Switch(
            activeColor: MyColor.switchColor,
            value: _swapSaveAndUndoButton,
            onChanged: (bool value) async {
              _swapSaveAndUndoButton = value;
              await SharedPreferenceHelper.sharedPreference.saveBoolData(
                  "swapSaveAndUndoButton", _swapSaveAndUndoButton);
              setState(() {});
            }),
        onTap: () async {
          _swapSaveAndUndoButton = !_swapSaveAndUndoButton;
          await SharedPreferenceHelper.sharedPreference
              .saveBoolData("swapSaveAndUndoButton", _swapSaveAndUndoButton);
          setState(() {});
        },
      ),
      ListTile(
        title: const Text('Save notes automatically').tr(),
        subtitle: const Text(
                'Changes in notes are saved automatically.\nDisabling it may cause losing unsaved parts of notes')
            .tr(),
        trailing: Switch(
            activeColor: MyColor.switchColor,
            value: _automaticallySaved,
            onChanged: (bool value) async {
              _automaticallySaved = value;
              await SharedPreferenceHelper.sharedPreference
                  .saveBoolData("automaticallySaved", _automaticallySaved);
              setState(() {});
            }),
        onTap: () async {
          _automaticallySaved = !_automaticallySaved;
          await SharedPreferenceHelper.sharedPreference
              .saveBoolData("automaticallySaved", _automaticallySaved);
          setState(() {});
        },
      ),
      ListTile(
        enabled: !_automaticallySaved,
        title: const Text('Confirm dropping unsaved changes').tr(),
        subtitle: const Text(
                'Asks for confirming before closing a note with unsaved changes')
            .tr(),
        trailing: Switch(
            activeColor: MyColor.switchColor,
            value: _droppingData,
            onChanged: _automaticallySaved
                ? null
                : (bool value) async {
                    _droppingData = value;
                    await SharedPreferenceHelper.sharedPreference
                        .saveBoolData("droppingData", _droppingData);
                    setState(() {});
                  }),
        onTap: () async {
          _droppingData = !_droppingData;
          await SharedPreferenceHelper.sharedPreference
              .saveBoolData("droppingData", _droppingData);
          setState(() {});
        },
      ),
      ListTile(
        enabled: !_automaticallySaved,
        title: const Text('Open notes in read mode').tr(),
        subtitle: const Text('Open notes in read mode by default').tr(),
        trailing: Switch(
            activeColor: MyColor.switchColor,
            value: _readMode,
            onChanged: (bool value) async {
              _readMode = value;
              await SharedPreferenceHelper.sharedPreference
                  .saveBoolData("readMode", _readMode);
              setState(() {});
            }),
        onTap: () async {
          _readMode = !_readMode;
          await SharedPreferenceHelper.sharedPreference
              .saveBoolData("readMode", _readMode);
          setState(() {});
        },
      ),
      ListTile(
        title: const Text('Keep screen on').tr(),
        subtitle: const Text('keep the screen from turning off').tr(),
        trailing: Switch(
            activeColor: MyColor.switchColor,
            value: _keepScreenOn,
            onChanged: (bool value) async {
              _keepScreenOn = value;
              await SharedPreferenceHelper.sharedPreference
                  .saveBoolData("keepScreenOn", _keepScreenOn);
              if (_keepScreenOn) {
                Wakelock.enable();
              } else {
                Wakelock.disable();
              }
              setState(() {});
            }),
        onTap: () async {
          _keepScreenOn = !_keepScreenOn;
          await SharedPreferenceHelper.sharedPreference
              .saveBoolData("keepScreenOn", _keepScreenOn);
          if (_keepScreenOn) {
            Wakelock.enable();
          } else {
            Wakelock.disable();
          }
          setState(() {});
        },
      ),
      ListTile(
        title: const Text('Draw lines in background').tr(),
        subtitle: const Text('Draw lines behind text in the background').tr(),
        trailing: Switch(
            activeColor: MyColor.switchColor,
            value: _drawLines,
            onChanged: (bool value) async {
              _drawLines = value;
              await SharedPreferenceHelper.sharedPreference
                  .saveBoolData("drawLines", _drawLines);
              setState(() {});
            }),
        onTap: () async {
          _drawLines = !_drawLines;
          await SharedPreferenceHelper.sharedPreference
              .saveBoolData("drawLines", _drawLines);

          setState(() {});
        },
      ),
    ];
    return Scaffold(
      backgroundColor: MyColor.backgroundScaffold,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: 'Menu'.tr(),
              icon: Icon(
                Icons.menu,
                size: 25,
                color: MyColor.textappBarColor,
              )),
        ),
        title: _showNotelistScreen
            ? Text("Note list",
                    style: TextStyle(color: MyColor.textappBarColor))
                .tr()
            : _showEditlistScreen
                ? Text("Note editing",
                        style: TextStyle(color: MyColor.textappBarColor))
                    .tr()
                : Text("Setting",
                        style: TextStyle(color: MyColor.textappBarColor))
                    .tr(),
        backgroundColor: MyColor.appBarColor,
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: _showNotelistScreen
              ? notelistScreen
              : _showEditlistScreen
                  ? editListScreen
                  : generalSetting,
        ),
      ),
    );
  }

  Future<void> alertPositionCursor(
      String title, String choice1, String choice2, int val) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title).tr(),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <ListTile>[
                    ListTile(
                      title: Text(choice1).tr(),
                      onTap: () {
                        if (val == 0) {
                          _cursorPosition = 1;
                        } else {
                          _language = 1;
                        }
                        setState(() {});
                      },
                      leading: Radio<int>(
                        activeColor: MyColor.switchColor,
                        value: 1,
                        groupValue: val == 0 ? _cursorPosition : _language,
                        onChanged: (int? value) {
                          if (val == 0) {
                            _cursorPosition = value!;
                          } else {
                            _language = value!;
                          }
                          setState(() {});
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(choice2).tr(),
                      onTap: () {
                        if (val == 0) {
                          _cursorPosition = 0;
                        } else {
                          _language = 0;
                        }
                        setState(() {});
                      },
                      leading: Radio<int>(
                        activeColor: MyColor.switchColor,
                        value: 0,
                        groupValue: val == 0 ? _cursorPosition : _language,
                        onChanged: (int? value) {
                          if (val == 0) {
                            _cursorPosition = value!;
                          } else {
                            _language = value!;
                          }
                          setState(() {});
                        },
                      ),
                    ),
                  ]);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: MyColor.textColor),
              ).tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: MyColor.textColor),
              ).tr(),
              onPressed: () async {
                if (val == 0) {
                  await SharedPreferenceHelper.sharedPreference
                      .saveIntData("cursorPosition", _cursorPosition);
                } else {
                  if (_language == 1) {
                    await EasyLocalization.of(context)!.setLocale(Locale("en"));
                  } else {
                    await EasyLocalization.of(context)!.setLocale(Locale("ar"));
                  }
                  await SharedPreferenceHelper.sharedPreference
                      .saveIntData("language", _language);
                }

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> changeTheme() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        int val = 5;
        return AlertDialog(
          title: Text('Theme').tr(),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <ListTile>[
                    ListTile(
                      title: Text('Light'),
                      // onTap: () {},
                      leading: Radio<int>(
                        activeColor: MyColor.switchColor,
                        value: 0,
                        groupValue: val,
                        onChanged: (int? value) {
                          val = value!;
                          setState(() {});
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('Solarized'),
                      // onTap: () {},
                      leading: Radio<int>(
                        activeColor: MyColor.switchColor,
                        value: 1,
                        groupValue: val,
                        onChanged: (int? value) {
                          val = value!;
                          setState(() {});
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('White'),
                      // onTap: () {},
                      leading: Radio<int>(
                        activeColor: MyColor.switchColor,
                        value: 2,
                        groupValue: val,
                        onChanged: (int? value) {
                          val = value!;
                          setState(() {});
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('Solarized Dark'),
                      // onTap: () {},
                      leading: Radio<int>(
                        activeColor: MyColor.switchColor,
                        value: 3,
                        groupValue: val,
                        onChanged: (int? value) {
                          val = value!;
                          setState(() {});
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('Dark'),
                      // onTap: () {},
                      leading: Radio<int>(
                        activeColor: MyColor.switchColor,
                        value: 4,
                        groupValue: val,
                        onChanged: (int? value) {
                          val = value!;
                          setState(() {});
                        },
                      ),
                    ),
                    ListTile(
                      title: Text('System setting'),
                      // onTap: () {},
                      leading: Radio<int>(
                        activeColor: MyColor.switchColor,
                        value: 5,
                        groupValue: val,
                        onChanged: (int? value) {
                          val = value!;
                          setState(() {});
                        },
                      ),
                    ),
                  ]);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: MyColor.textColor),
              ).tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: MyColor.textColor),
              ).tr(),
              onPressed: () async {
                // await SharedPreferenceHelper.sharedPreference
                //     .saveIntData("cursorPosition", _cursorPosition);
                switch (val) {
                  case 0:
                    MyColor.colors.appBarColorSet(Color(0xffEFE8D5));
                    MyColor.colors.backgroundScaffoldSet(Color(0xffFDF6E3));
                    MyColor.colors.switchColorSet(Color(0xffB68505));
                    MyColor.colors.textColorSet(Color(0xff7D7159));
                    MyColor.colors.topDrawerSet(Color(0xffC39F2F));
                    MyColor.colors.backgroundDrawerSet(Color(0xffFDF6E3));
                    setState(() {});
                    break;
                  default:
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
