import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notepad/widgets/back_text_button.dart';
import '../helper/file_helper.dart';
import '../helper/shared_preference_helper.dart';
import '../helper/toast_helper.dart';
import '../models/Category.dart';
import '../widgets/nestedPopupMenuItem.dart';
import '../helper/app_router.dart';
import '../helper/db_helper.dart';
import '../models/note.dart';

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final FocusNode _contentFocusNode = FocusNode();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  String _unUndoAll = "";
  String cat = "";
  int _undo = 0;
  int _intCounterTapOnText = 0;
  int _cursorPosition = 0;
  List<String> checkLinks = <String>[];
  List<Note> notesList = <Note>[];
  List<Category> categoryList = <Category>[];
  bool _startWriting = false;
  bool _finishGetDataCategories = false;
  bool _finishGetData = false;
  bool _replaceContent = false;
  bool _enableUndoAllAndRedo = false;
  bool _enableEditMode = true;
  bool _showNoteKeyboard = false;
  bool _swapSaveAndUndoButton = false;
  bool _automaticallySaved = true;
  bool _droppingData = false;
  bool _readMode = false;
  bool _drawLines = false;
  bool firstTime = true;

  @override
  void initState() {
    super.initState();

    getCategoryData();
    getNotesData();
    initialData();
  }

  void initialData() {
    _showNoteKeyboard = SharedPreferenceHelper.sharedPreference
            .getBoolData("showNoteKeyboard") ??
        false;
    _cursorPosition =
        SharedPreferenceHelper.sharedPreference.getIntData("cursorPosition") ??
            0;

    _swapSaveAndUndoButton = SharedPreferenceHelper.sharedPreference
            .getBoolData("swapSaveAndUndoButton") ??
        false;
    _automaticallySaved = SharedPreferenceHelper.sharedPreference
            .getBoolData("automaticallySaved") ??
        true;
    _droppingData =
        SharedPreferenceHelper.sharedPreference.getBoolData("droppingData") ??
            false;
    _readMode =
        SharedPreferenceHelper.sharedPreference.getBoolData("readMode") ??
            false;
    _drawLines =
        SharedPreferenceHelper.sharedPreference.getBoolData("drawLines") ??
            false;

    if (_readMode) _enableEditMode = false;
  }

  Future<void> getNotesData() async {
    await DBHelper.dbhelper
        .getAllNotes()
        .then((List<Note> value) => notesList = value);
  }

  Future<void> getCategoryData() async {
    DBHelper.dbhelper
        .getAllCategories()
        .then((List<Category> value) => categoryList = value);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote(int id, bool showToast) {
    final bool isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    if (id != -1) {
      // this is to update a exsit note

      final Note note = Note(
          id: id,
          title: _titleController.text,
          content: _contentController.text,
          dateEdition: DateTime.now().toString(),
          dateCreation: dateCreation,
          cat: cat);
      DBHelper.dbhelper.updateNote(note);
      if (showToast) ToastHelper.flutterToast("The note was updated");
    } else {
      // create new note
      final Note note = Note(
        title: _titleController.text,
        content: _contentController.text,
        dateCreation: DateTime.now().toString(),
        dateEdition: DateTime.now().toString(),
        cat: cat,
      );
      DBHelper.dbhelper.createNote(note);
      AppRouter.route.replacmentRoute('/home');
      if (showToast) ToastHelper.flutterToast("The note was saved");
    }
  }

  Map<String?, dynamic> data = <String?, dynamic>{};
  int id = -1;
  String title = "";
  String content = "";
  String dateCreation = DateTime.now().toString();
  String dateEdition = "";
  @override
  Widget build(BuildContext context) {
    if (!_finishGetData) {
      getNotesData().whenComplete(() {
        if (mounted) {
          _finishGetData = true;
          selectedPositionCursor();
          setState(() {});
        }
      });
    }
    if (!_finishGetDataCategories) {
      getCategoryData().whenComplete(() {
        if (mounted) {
          _finishGetDataCategories = true;

          setState(() {});
        }
      });
    }
    if (ModalRoute.of(context)!.settings.arguments != null) {
      data =
          ModalRoute.of(context)!.settings.arguments as Map<String?, dynamic>;
      id = int.parse(data['id'] as String);
      title = data['title'] as String;
      content = data['content'] as String;
      dateCreation = data['dateCreation'] as String;
      dateEdition = data['dateEdition'] as String;
      if (!_replaceContent) {
        _titleController.text = title;
        _contentController.text = content;
        _replaceContent = !_replaceContent;
      }
      setState(() {});
    }

    List<Widget> actionsSwapSaveAndUndoButton = <Widget>[
      TextButton(
        onPressed: () {
          if (id == -1) {
            _saveNote(-1, true);
          } else {
            _saveNote(id, true);
          }
        },
        child: const Text(
          'Save',
          style: TextStyle(fontSize: 20, color: Color(0xff888888)),
        ).tr(),
      ),
      if (_contentController.text.isEmpty)
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Undo',
              style: TextStyle(fontSize: 20, color: Color(0xff888888)),
            ).tr(),
          ),
        )
      else
        TextButton(
          onPressed: () {
            if (_contentController.text.isNotEmpty) {
              if (_contentController.text.length > _unUndoAll.length)
                _unUndoAll = _contentController.text;
              _contentController.text = _contentController.text.trimRight();
              _contentController.text = _contentController.text
                  .substring(0, _contentController.text.length - 1);
              _undo = _contentController.text.length;
              _enableUndoAllAndRedo = true;
              _contentController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _contentController.text.length));
              setState(() {});
            }
          },
          child: const Text(
            'Undo',
            style: TextStyle(fontSize: 20, color: Color(0xff888888)),
          ).tr(),
        ),
      popMenuItems(),
    ];

    List<Widget> actionsSwapSaveAndUndoButtonReversed = <Widget>[
      if (_contentController.text.isEmpty)
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              'Undo',
              style: TextStyle(fontSize: 20, color: Color(0xff888888)),
            ).tr(),
          ),
        )
      else
        TextButton(
          onPressed: () {
            if (_contentController.text.isNotEmpty) {
              if (_contentController.text.length > _unUndoAll.length)
                _unUndoAll = _contentController.text;
              _contentController.text = _contentController.text.trimRight();
              _contentController.text = _contentController.text
                  .substring(0, _contentController.text.length - 1);
              _undo = _contentController.text.length;
              _enableUndoAllAndRedo = true;
              _contentController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _contentController.text.length));
              setState(() {});
            }
          },
          child: const Text(
            'Undo',
            style: TextStyle(fontSize: 20, color: Color(0xff888888)),
          ).tr(),
        ),
      TextButton(
        onPressed: () {
          if (id == -1) {
            _saveNote(-1, true);
          } else {
            _saveNote(id, true);
          }
        },
        child: const Text(
          'Save',
          style: TextStyle(fontSize: 20, color: Color(0xff888888)),
        ).tr(),
      ),
      popMenuItems(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notepad").tr(),
        leading: IconButton(
            onPressed: () {
              if (_droppingData && !_automaticallySaved) {
                warningDialog();
              } else {
                AppRouter.route.replacmentRoute('/home');
              }
            },
            icon: const Icon(Icons.arrow_back)),
        actions: _swapSaveAndUndoButton
            ? actionsSwapSaveAndUndoButton
            : actionsSwapSaveAndUndoButtonReversed,
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  readOnly: !_enableEditMode,
                  controller: _titleController,
                  autofocus:
                      _titleController.text == "" ? _showNoteKeyboard : false,
                  maxLines: 1,
                  onChanged: (value) {
                    if (_automaticallySaved) {
                      if (id != -1) {
                        _saveNote(id, false);
                      }
                    }
                  },
                  enableInteractiveSelection: _enableEditMode,
                  onTap: () {
                    if (!_enableEditMode) {
                      _intCounterTapOnText++;
                      if (_intCounterTapOnText > 1) {
                        ToastHelper.flutterToast("Switch to write mode");
                        _intCounterTapOnText = 0;
                        _enableEditMode = true;
                        setState(() {});
                      } else {
                        ToastHelper.flutterToast(
                            "Click again to back to write mode");
                      }
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter title...'.tr(),
                    hintStyle: TextStyle(fontSize: 18),
                  ),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_contentFocusNode);
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Stack(
                    children: [
                      for (double i = 0; i < 1000; i += 28)
                        _drawLines
                            ? Positioned(
                                bottom: i,
                                right: 0,
                                left: 0,
                                child: Divider(),
                              )
                            : Container(),
                      TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        readOnly: !_enableEditMode,
                        enableInteractiveSelection: _enableEditMode,
                        focusNode: _contentFocusNode,
                        maxLines: null,
                        onTap: () {
                          if (!_enableEditMode) {
                            _intCounterTapOnText++;

                            if (_intCounterTapOnText > 1) {
                              ToastHelper.flutterToast("Switch to write mode");
                              _intCounterTapOnText = 0;
                              _enableEditMode = true;
                              setState(() {});
                            } else {
                              ToastHelper.flutterToast(
                                  "Click again to back to write mode");
                            }
                          }
                        },
                        keyboardType: TextInputType.multiline,
                        onChanged: (String value) {
                          if (value.isNotEmpty && !_startWriting) {
                            _startWriting = !_startWriting;
                            setState(() {});
                          }

                          if (_automaticallySaved) {
                            if (id != -1) {
                              _saveNote(id, false);
                            }
                          }
                        },
                        autofocus: _titleController.text != ""
                            ? _showNoteKeyboard
                            : false,
                        minLines: 50,
                        controller: _contentController,
                        style: TextStyle(
                            height: _drawLines ? 1.41 : 1, fontSize: 18),
                        decoration: InputDecoration(
                          hintText: 'Enter text...'.tr(),
                          hintStyle: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectedPositionCursor() {
    if (_titleController.text != "") {
      if (_cursorPosition == 0) {
        _contentController.selection = TextSelection.fromPosition(
            TextPosition(offset: _contentController.text.length));
      } else {
        _contentController.selection =
            TextSelection.fromPosition(TextPosition(offset: 0));
      }
    } else {
      if (_cursorPosition == 0) {
        _titleController.selection = TextSelection.fromPosition(
            TextPosition(offset: _titleController.text.length));
      } else {
        _titleController.selection =
            TextSelection.fromPosition(TextPosition(offset: 0));
      }
    }
  }

  PopupMenuButton popMenuItems() {
    return PopupMenuButton<int>(
      child: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext bc) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
            enabled: _enableUndoAllAndRedo,
            child: const Text("Redo").tr(),
            value: 0),
        const PopupMenuDivider(),
        PopupMenuItem<int>(
            enabled: _enableUndoAllAndRedo,
            child: const Text("Undo all").tr(),
            value: 1),
        const PopupMenuDivider(),
        PopupMenuItem<int>(child: NestedPopupMenuItem(), value: null),
        const PopupMenuDivider(),
        PopupMenuItem<int>(child: Text("Delete").tr(), value: 3),
        const PopupMenuDivider(),
        PopupMenuItem<int>(child: Text("Export to a text file").tr(), value: 4),
        const PopupMenuDivider(),
        PopupMenuItem<int>(child: Text("Categories").tr(), value: 5),
        const PopupMenuDivider(),
        PopupMenuItem<int>(child: Text("Switch to read mode").tr(), value: 6),
        const PopupMenuDivider(),
      ],
      onSelected: (int value) async {
        switch (value) {
          case 0:
            if (_undo < _unUndoAll.length) ++_undo;
            _contentController.text = _unUndoAll.substring(0, _undo);
            break;
          case 1:
            _contentController.text = _unUndoAll;
            break;

          case 3:
            alertDeleteNote();
            break;

          case 4:
            await FileHelper.files.writeInFile(
                _titleController.text == ""
                    ? "Untitled".tr()
                    : _titleController.text,
                _titleController.text + "::" + _contentController.text);
            ToastHelper.flutterToast("The file was exported");
            break;
          case 5:
            addCategoriesToNotes();
            break;
          case 6:
            _enableEditMode = !_enableEditMode;
            if (_enableEditMode) {
              ToastHelper.flutterToast("Switch to write mode");
            } else {
              ToastHelper.flutterToast("Switch to read mode");
            }
            setState(() {});
            break;
          default:
        }
      },
    );
  }

  Future<void> alertDeleteNote() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // !user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Text>[
              Text(
                  "${"The".tr()} '${_titleController.text == "" ? "Untitled".tr() : _titleController.text}' ${"note will be deleted. Are you sure?".tr()}"),
            ],
          ),
          actions: <TextButton>[
            TextButton(
              child: Text('CANCEL').tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK').tr(),
              onPressed: () {
                if (id != -1) {
                  Note dn = Note(
                      id: id,
                      title: title,
                      content: content,
                      dateEdition: dateEdition,
                      dateCreation: dateCreation,
                      cat: cat);
                  Note note = Note(
                      id: id,
                      title: title,
                      content: content,
                      dateEdition: dateEdition,
                      dateCreation: dateCreation,
                      cat: cat);
                  bool moveDeletedToTrash = SharedPreferenceHelper
                          .sharedPreference
                          .getBoolData("moveDeletedToTrash") ??
                      true;
                  if (moveDeletedToTrash) {
                    DBHelper.dbhelper.createDeletedNote(dn);
                  }
                  DBHelper.dbhelper.deleteNote(note);
                  Navigator.of(context).pop();
                  AppRouter.route.replacmentRoute('/home');
                } else {
                  Note dn = Note(
                      title: title == "" ? "Untitled" : title,
                      content: content,
                      dateEdition: DateTime.now().toString(),
                      dateCreation: DateTime.now().toString(),
                      cat: cat);
                  bool moveDeletedToTrash = SharedPreferenceHelper
                          .sharedPreference
                          .getBoolData("moveDeletedToTrash") ??
                      true;
                  if (moveDeletedToTrash) {
                    DBHelper.dbhelper.createDeletedNote(dn);
                  }
                  Navigator.of(context).pop();
                  AppRouter.route.replacmentRoute('/home');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> addCategoriesToNotes() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        List<bool> isCheck = <bool>[];
        isCheck = List<bool>.filled(categoryList.length, false);
        return AlertDialog(
          title: const Text('Select category').tr(),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return !_finishGetDataCategories
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children: categoryList
                            .asMap()
                            .map(
                              (int i, Category e) {
                                return MapEntry<int, Column>(
                                  i,
                                  Column(
                                    children: <Widget>[
                                      CheckboxListTile(
                                        value: isCheck[i],
                                        onChanged: (bool? value) {
                                          isCheck[i] = value!;
                                          setState(() {});
                                        },
                                        title: Text("${e.nameCat}"),
                                        dense: true,
                                      ),
                                      const Divider()
                                    ],
                                  ),
                                );
                              },
                            )
                            .values
                            .toList(),
                      ),
                    );
            },
          ),
          actions: <Widget>[
            BackTextButton(),
            TextButton(
              child: Text('OK').tr(),
              onPressed: () {
                // for (int i = 0; i < isCheck.length; i++) {
                //   if (isCheck[i]) {
                //     if (!cat.contains(categoryList[i].nameCat!)) {
                //       cat += categoryList[i].nameCat! + ", ";
                //     }
                //   }
                // }

                // cat = cat.trimRight().substring(0, cat.length - 1);
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> warningDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        bool val = false;
        return AlertDialog(
          title: const Text('Do you want to drop the unsaved changes?').tr(),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CheckboxListTile(
                    title: Text("Do not ask again").tr(),
                    value: val,
                    onChanged: (bool? value) {
                      val = value!;
                      setState(() {});
                    },
                  ),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel').tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK').tr(),
              onPressed: () async {
                if (val) {
                  await SharedPreferenceHelper.sharedPreference
                      .saveBoolData('droppingData', false);
                }
                setState(() {});
                AppRouter.route.replacmentRoute('/home');
              },
            ),
          ],
        );
      },
    );
  }
}
