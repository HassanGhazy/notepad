import 'package:flutter/material.dart';
import 'package:notepad/helper/luncher_helper.dart';
import 'package:notepad/helper/mycolor.dart';
import 'package:notepad/helper/shared_preference_helper.dart';
import 'package:notepad/widgets/my_drawer.dart';
import 'package:wakelock/wakelock.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    // The setting of note list screens
    List<ListTile> notelistScreen = [
      ListTile(
        title: const Text("Open the last chosen category"),
        subtitle: const Text("Opens the last chosen category on app start"),
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
        title: const Text("Show note categories"),
        subtitle: const Text("Show categories for each note on the list"),
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
        title: const Text("Theme"),
        subtitle: const Text("Changes color theme of visible elements"),
      ),
      ListTile(
        title: const Text("Note list"),
        onTap: () {
          _showNotelistScreen = true;
          setState(() {});
        },
      ),
      ListTile(
        title: const Text("Note editing"),
        onTap: () {
          _showEditlistScreen = true;
          setState(() {});
        },
      ),
      ListTile(
        title: const Text("Move deleted notes to 'Trash'"),
        subtitle:
            const Text("Deleted notes will be stored in the 'Trash' folder"),
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
        title: const Text("Privacy setting"),
        subtitle: Text("Opens the privacy policy document."),
        onTap: () {
          LauncherHelper.launcher.openWebPage(
              "https://docs.google.com/document/d/1Irv9J70PnafXkBnI-9E_XHMCI_3DfuEzqESLfgQ_DEY/edit?usp=sharing");
        },
      ),
    ];
    // The setting of edit note list screen
    List<ListTile> editListScreen = [
      ListTile(
        title: const Text("Show note keyboard"),
        subtitle: const Text("show keyboard after entering the note screen"),
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
        title: const Text("Cursor position in a note"),
        subtitle: const Text(
            "Cursor position after opening a note with keyboard visible"),
        onTap: () {
          alertPositionCursor();
        },
      ),
      ListTile(
        title: const Text('Switch "Save" and "Undo" buttons'),
        subtitle:
            const Text('Switches the "Save" and "Undo" buttons placement'),
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
        title: const Text('Save notes automatically'),
        subtitle: const Text(
            'Changes in notes are saved automatically.\nDisabling it may cause losing unsaved parts of notes'),
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
        title: const Text('Confirm dropping unsaved changes'),
        subtitle: const Text(
            'Asks for confirming before closing a note with unsaved changes'),
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
        title: const Text('Open notes in read mode'),
        subtitle: const Text('Open notes in read mode by default'),
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
        title: const Text('Keep screen on'),
        subtitle:
            const Text('keep the screen from turning off after opening a note'),
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
        title: const Text('Draw lines in background'),
        subtitle: const Text('Draw lines behind text in the background'),
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
        title: _showNotelistScreen
            ? const Text("Note list")
            : _showEditlistScreen
                ? const Text("Note editing")
                : const Text("Setting"),
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

  Future<void> alertPositionCursor() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cursor position in a note'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <ListTile>[
                    ListTile(
                      title: const Text("Cursor at the beginning of a note"),
                      onTap: () => setState(() => _cursorPosition = 1),
                      leading: Radio<int>(
                        activeColor: MyColor.switchColor,
                        value: 1,
                        groupValue: _cursorPosition,
                        onChanged: (int? value) =>
                            setState(() => _cursorPosition = value!),
                      ),
                    ),
                    ListTile(
                      title: const Text("Cursor at the end of a note"),
                      onTap: () => setState(() => _cursorPosition = 0),
                      leading: Radio<int>(
                        activeColor: MyColor.switchColor,
                        value: 0,
                        groupValue: _cursorPosition,
                        onChanged: (int? value) =>
                            setState(() => _cursorPosition = value!),
                      ),
                    ),
                  ]);
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: MyColor.textColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: MyColor.textColor),
              ),
              onPressed: () async {
                await SharedPreferenceHelper.sharedPreference
                    .saveIntData("cursorPosition", _cursorPosition);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
