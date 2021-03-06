import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import '../helper/file_helper.dart';
import '../helper/toast_helper.dart';
import '../helper/db_helper.dart';
import '../helper/mycolor.dart';

import '../models/note.dart';
import '../widgets/my_drawer.dart';

class TrashScreen extends StatefulWidget {
  @override
  _TrashScreenState createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  List<bool> selectedNote = <bool>[].toList();
  bool selectedIsRunning = false;
  int count = 0;
  List<Note> deletedNotesList = <Note>[];
  bool _finishGetData = false;
  @override
  void initState() {
    super.initState();
    getDeletedNotesListData();
  }

  Future<void> getDeletedNotesListData() async {
    await DBHelper.dbhelper
        .getAllDeletedNotes()
        .then((List<Note> value) => deletedNotesList = value);
  }

  Future<void> deleteNotesAlert(String text, int val) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // !user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(text),
          actions: <TextButton>[
            TextButton(
              child: Text(
                'CANCEL',
                // style: TextStyle(
                //     fontWeight: FontWeight.bold, color: MyColor.textColor),
              ).tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('OK').tr(),
              onPressed: () {
                switch (val) {
                  case 0: // restore all the notes
                    final int length = deletedNotesList.length;
                    for (int i = length - 1; i >= 0; i--) {
                      final Note note =
                          Note.fromMap(deletedNotesList[i].toMap());
                      DBHelper.dbhelper.createNote(note);
                      DBHelper.dbhelper.deleteNoteForever(deletedNotesList[i]);
                      selectedNote.removeAt(i);
                      deletedNotesList.removeAt(i);
                    }
                    count = 0;
                    break;
                  case 1: // restoer the selected notes
                    final int length = selectedNote.length;
                    for (int i = length - 1; i >= 0; i--) {
                      if (selectedNote[i]) {
                        final Note note =
                            Note.fromMap(deletedNotesList[i].toMap());
                        DBHelper.dbhelper.createNote(note);
                        DBHelper.dbhelper
                            .deleteNoteForever(deletedNotesList[i]);
                        selectedNote.removeAt(i);
                        deletedNotesList.removeAt(i);
                        count--;
                      }
                    }
                    break;
                  case 2: // empty Trash
                    final int length = deletedNotesList.length;
                    for (int i = length - 1; i >= 0; i--) {
                      DBHelper.dbhelper.deleteNoteForever(deletedNotesList[i]);
                      deletedNotesList.removeAt(i);
                    }
                    count = 0;
                    selectedIsRunning = false;
                    break;

                  case 3: // delete All notes
                    final int length = selectedNote.length;
                    for (int i = length - 1; i >= 0; i--) {
                      if (selectedNote[i]) {
                        DBHelper.dbhelper
                            .deleteNoteForever(deletedNotesList[i]);
                        selectedNote.removeAt(i);
                        deletedNotesList.removeAt(i);
                      }
                    }
                    count = 0;
                    selectedIsRunning = false;
                    break;

                  default:
                }

                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> alertSpecficNote(Note e) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // !user must tap button!
      builder: (BuildContext context) {
        int val = 1;
        return AlertDialog(
          content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                    "${e.title! == "" ? "Untitled".tr() : e.title!}\n${e.content!.length > 100 ? e.content!.replaceAll('\n', '').substring(0, 100) : e.content!.replaceAll('\n', '')}"),
                const Divider(),
                const Text('Select an action for the note:').tr(),
                ListTile(
                  title: const Text("Undelete").tr(),
                  onTap: () => setState(() => val = 1),
                  leading: Radio<int>(
                    value: 1,
                    groupValue: val,
                    onChanged: (int? value) => setState(() => val = value!),
                  ),
                ),
                ListTile(
                  title: const Text("Delete").tr(),
                  onTap: () => setState(() => val = 2),
                  leading: Radio<int>(
                    value: 2,
                    groupValue: val,
                    onChanged: (int? value) => setState(() => val = value!),
                  ),
                ),
              ],
            );
          }),
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
                if (val == 1) {
                  // restore
                  final Note note = Note.fromMap(e.toMap());
                  DBHelper.dbhelper.createNote(note);
                  DBHelper.dbhelper.deleteNoteForever(e);
                  deletedNotesList.remove(e);
                } else {
                  // delete
                  DBHelper.dbhelper.deleteNoteForever(e);
                  deletedNotesList.remove(e);
                }
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_finishGetData) {
      getDeletedNotesListData().whenComplete(() {
        if (mounted) {
          _finishGetData = true;

          setState(() {});
        }
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: selectedIsRunning ? Text('$count') : const Text('Trash').tr(),
        actions: selectedIsRunning
            ? <Widget>[
                IconButton(
                  tooltip: 'Select all the notes'.tr(),
                  onPressed: () {
                    for (int i = 0; i < selectedNote.length; i++) {
                      selectedNote[i] = true;
                    }
                    count = selectedNote.length;
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.select_all,
                    // color: Color(0xffffffff),
                    size: 25,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    deleteNotesAlert("Restore the selected notes?".tr(), 1);
                  },
                  tooltip: 'Undelete'.tr(),
                  icon: const Icon(
                    Icons.delete_sweep,
                    // color: Color(0xffffffff),
                    size: 25,
                  ),
                ),
                popMenuSelectedItems()
              ]
            : <PopupMenuButton<int>>[
                popMenuItems(),
              ],
        leading: selectedIsRunning
            ? IconButton(
                onPressed: () {
                  selectedIsRunning = false;
                  selectedNote = List<bool>.filled(selectedNote.length, false,
                      growable: true);
                  count = 0;
                  setState(() {});
                },
                icon: const Icon(Icons.arrow_back))
            : Builder(
                builder: (BuildContext context) => IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip: 'Menu'.tr(),
                    icon: const Icon(
                      Icons.menu,
                      size: 25,
                      // color: Color(0xffffffff),
                    )),
              ),
      ),
      drawer: MyDrawer(),
      body: !_finishGetData
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: deletedNotesList
                    .asMap()
                    .map((int i, Note e) {
                      while (deletedNotesList.length > selectedNote.length) {
                        selectedNote.insert(0, false);
                      }

                      return MapEntry<int, Card>(
                        i,
                        Card(
                          elevation: 0,
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                  // color: Colors.black,
                                  ),
                              gradient: selectedNote[i]
                                  ? LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: <Color>[
                                        MyColor.linear1Selected,
                                        MyColor.linear2Selected,
                                      ],
                                    )
                                  : LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: <Color>[
                                        MyColor.linear1WithoutSelected,
                                        MyColor.linear1WithoutSelected,
                                      ],
                                    ),
                            ),
                            child: ListTile(
                              title: Text(
                                  "${e.title! == "" ? "Untitled".tr() : e.title!}"),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "${"Last edit:".tr()}${DateFormat("d/M/yy, hh:mm a").format(DateTime.parse(e.dateEdition!))}",
                                    // style: const TextStyle(
                                    //     color: Color(0xff000000)),
                                  ),
                                ],
                              ),
                              onTap: () {
                                if (selectedIsRunning) {
                                  selectedNote[i] = !selectedNote[i];
                                  if (selectedNote[i]) {
                                    count++;
                                  } else {
                                    count--;
                                  }
                                  setState(() {});
                                } else {
                                  // show dialog
                                  alertSpecficNote(e);
                                }
                              },
                              onLongPress: () {
                                selectedIsRunning = true;
                                selectedNote[i] = !selectedNote[i];
                                if (selectedNote[i]) {
                                  count++;
                                } else {
                                  count--;
                                }
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      );
                    })
                    .values
                    .toList(),
              ),
            ),
    );
  }

  PopupMenuButton<int> popMenuItems() {
    return PopupMenuButton<int>(
      child: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext bc) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(child: Text("Undelete all").tr(), value: 0),
        PopupMenuItem<int>(
            child: Text("Export notes to text files").tr(), value: 1),
        PopupMenuItem<int>(child: Text("Empty Trash").tr(), value: 2),
      ],
      onSelected: (int value) async {
        switch (value) {
          case 0:
            deleteNotesAlert("Restore all notes".tr(), 0);
            break;
          case 1:
            for (int i = 0; i < deletedNotesList.length; i++) {
              await FileHelper.files.writeInFile(
                  deletedNotesList[i].title == ""
                      ? "Untitled".tr()
                      : deletedNotesList[i].title!,
                  deletedNotesList[i].title! +
                      "::" +
                      deletedNotesList[i].content!);
            }

            ToastHelper.flutterToast("The file(s) was exported");
            break;
          case 2:
            deleteNotesAlert(
                "All trashed notes will be deleted permanently. Are you sure that you want to delete all of the trashed notes?"
                    .tr(),
                2);
            break;
          default:
        }
      },
    );
  }

  Widget popMenuSelectedItems() {
    return PopupMenuButton<int>(
      child: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext bc) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
            child: Text("Export notes to text files").tr(), value: 0),
        PopupMenuItem<int>(child: Text("Delete").tr(), value: 1),
      ],
      onSelected: (int value) {
        switch (value) {
          case 0:
            break;
          case 1:
            deleteNotesAlert(
                "Are you sure that you want to delete the selected notes? the notes will be deleted permanently."
                    .tr(),
                3);
            break;

          default:
        }
      },
    );
  }
}
