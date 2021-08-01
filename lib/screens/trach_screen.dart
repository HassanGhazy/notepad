import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notepad/helper/db_helper.dart';
import 'package:notepad/helper/mycolor.dart';
import 'package:notepad/models/deletedNote.dart';
import 'package:notepad/models/note.dart';
// import 'package:notepad/provider/note_provider.dart';
import 'package:notepad/widgets/my_drawer.dart';
// import 'package:provider/provider.dart';

class TrashScreen extends StatefulWidget {
  @override
  _TrashScreenState createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen> {
  List<bool> selectedNote = <bool>[].toList();
  bool selectedIsRunning = false;
  int count = 0;
  List<DeletedNote> deletedNotesList = [];
  bool _finishGetData = false;
  @override
  void initState() {
    super.initState();
    getDeletedNotesListData();
  }

  Future<void> getDeletedNotesListData() async {
    await DBHelper.dbhelper
        .getAllDeletedNotes()
        .then((value) => deletedNotesList = value);
  }

  Future<void> deleteNotesAlert(String text, int val) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // !user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: val == 4
              ? Column(
                  children: [
                    Text(text),
                    Divider(),
                    Text('Select an action for the note:'),
                  ],
                )
              : Text(text),
          actions: <TextButton>[
            TextButton(
              child: const Text(
                'CANCEL',
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
              onPressed: () {
                switch (val) {
                  case 0: // restore all the notes
                    int length = deletedNotesList.length;
                    for (int i = length - 1; i >= 0; i--) {
                      Note note = Note.fromMap(deletedNotesList[i].toMap());
                      DBHelper.dbhelper.createNote(note);
                      DBHelper.dbhelper.deleteNoteForever(deletedNotesList[i]);
                      selectedNote.removeAt(i);
                      deletedNotesList.removeAt(i);
                    }
                    count = 0;
                    break;
                  case 1: // restoer the selected notes
                    int length = selectedNote.length;
                    for (int i = length - 1; i >= 0; i--) {
                      if (selectedNote[i]) {
                        Note note = Note.fromMap(deletedNotesList[i].toMap());
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
                    int length = deletedNotesList.length;
                    for (int i = length - 1; i >= 0; i--) {
                      DBHelper.dbhelper.deleteNoteForever(deletedNotesList[i]);
                      deletedNotesList.removeAt(i);
                    }
                    count = 0;
                    selectedIsRunning = false;
                    break;

                  case 3: // delete All notes
                    int length = selectedNote.length;
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

  Future<void> alertSpecficNote(DeletedNote e) async {
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
              children: [
                Text(
                    "${e.title! == "" ? "Untitled" : e.title!}\n${e.content!.length > 100 ? e.content!.replaceAll('\n', '').substring(0, 100) : e.content!.replaceAll('\n', '')}"),
                Divider(),
                Text('Select an action for the note:'),
                ListTile(
                  title: Text("Undelete"),
                  onTap: () => setState(() => val = 1),
                  leading: Radio(
                    value: 1,
                    groupValue: val,
                    onChanged: (int? value) => setState(() => val = value!),
                  ),
                ),
                ListTile(
                  title: Text("Delete"),
                  onTap: () => setState(() => val = 2),
                  leading: Radio(
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
              child: const Text(
                'CANCEL',
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
              onPressed: () {
                if (val == 1) {
                  // restore
                  Note note = Note.fromMap(e.toMap());
                  DBHelper.dbhelper.createNote(note);
                  DBHelper.dbhelper.deleteNoteForever(e);
                  print(deletedNotesList.length);
                  deletedNotesList.remove(e);
                  print(deletedNotesList.length);
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
    // final listDeletedNotes =
    //     Provider.of<NoteProvider>(context, listen: false).deletedNotes;
    if (!_finishGetData) {
      getDeletedNotesListData().whenComplete(() {
        if (!mounted) return;
        _finishGetData = true;
        setState(() {});
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: selectedIsRunning ? Text('$count') : Text('Trash'),
        backgroundColor: MyColor.appBarColor,
        actions: selectedIsRunning
            ? [
                IconButton(
                  tooltip: 'Select all the notes',
                  onPressed: () {
                    for (int i = 0; i < selectedNote.length; i++) {
                      selectedNote[i] = true;
                    }
                    count = selectedNote.length;
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.select_all,
                    color: Color(0xffffffff),
                    size: 25,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    deleteNotesAlert("Restore the selected notes?", 1);
                  },
                  tooltip: 'Undelete',
                  icon: const Icon(
                    Icons.delete_sweep,
                    color: Color(0xffffffff),
                    size: 25,
                  ),
                ),
                popMenuSelectedItems()
              ]
            : [
                popMenuItems(),
              ],
        leading: selectedIsRunning
            ? IconButton(
                onPressed: () {
                  selectedIsRunning = false;
                  selectedNote =
                      List.filled(selectedNote.length, false, growable: true);
                  count = 0;
                  setState(() {});
                },
                icon: Icon(Icons.arrow_back))
            : Builder(
                builder: (context) => IconButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    tooltip: 'Menu',
                    icon: Icon(
                      Icons.menu,
                      size: 25,
                      color: Color(0xffffffff),
                    )),
              ),
      ),
      drawer: MyDrawer(),
      backgroundColor: MyColor.backgroundScaffold,
      body: !_finishGetData
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: deletedNotesList
                    .asMap()
                    .map((i, e) {
                      while (deletedNotesList.length > selectedNote.length) {
                        selectedNote.insert(0, false);
                      }

                      return MapEntry(
                        i,
                        Card(
                          elevation: 0,
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius:
                                  new BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: Colors.black,
                              ),
                              gradient: selectedNote[i]
                                  ? MyColor.containerColorWithSelected
                                  : MyColor.containerColorWithoutSelected,
                            ),
                            child: ListTile(
                              title: Text(
                                  "${e.title! == "" ? "Untitled" : e.title!}"),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Last edit: ${DateFormat("d/M/yy, hh:mm a").format(DateTime.parse(e.dateEdition!))}",
                                    style: TextStyle(color: Color(0xff000000)),
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

  Widget popMenuItems() {
    return PopupMenuButton(
      child: Icon(Icons.more_vert),
      itemBuilder: (BuildContext bc) => [
        PopupMenuItem(child: Text("Undelete all"), value: 0),
        PopupMenuItem(child: Text("Export notes to text files"), value: 1),
        PopupMenuItem(child: Text("Empty Trash"), value: 2),
      ],
      onSelected: (value) {
        switch (value) {
          case 0:
            deleteNotesAlert("Restore all notes", 0);
            break;
          case 1:
            break;
          case 2:
            deleteNotesAlert(
                "All trashed notes will be deleted permanently. Are you sure that you want to delete all of the trashed notes?",
                2);
            break;
          default:
        }
      },
    );
  }

  Widget popMenuSelectedItems() {
    return PopupMenuButton(
      child: Icon(Icons.more_vert),
      itemBuilder: (BuildContext bc) => [
        PopupMenuItem(child: Text("Export notes to text files"), value: 0),
        PopupMenuItem(child: Text("Delete"), value: 1),
      ],
      onSelected: (value) {
        switch (value) {
          case 0:
            break;
          case 1:
            deleteNotesAlert(
                "Are you sure that you want to delete the selected notes? the notes will be deleted permanently.",
                3);
            break;

          default:
        }
      },
    );
  }
}
