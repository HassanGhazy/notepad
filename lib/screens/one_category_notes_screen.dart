import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notepad/helper/shared_preference_helper.dart';
import '../helper/app_router.dart';
import '../helper/db_helper.dart';
import '../helper/mycolor.dart';
import '../models/Category.dart';

import '../models/note.dart';
import '../widgets/my_drawer.dart';

class OneCategoryNotesScreen extends StatefulWidget {
  const OneCategoryNotesScreen(this.text);
  final String text;
  @override
  _OneCategoryNotesScreenState createState() => _OneCategoryNotesScreenState();
}

class _OneCategoryNotesScreenState extends State<OneCategoryNotesScreen> {
  List<Note> notesList = <Note>[];
  List<bool> selectedNote = <bool>[].toList();
  bool selectedIsRunning = false;
  int count = 0;
  List<Category> categoryList = <Category>[];
  bool _finishGetDataCategories = false;
  bool _finishGetDataNotes = false;
  Future<void> getNotesData() async {
    DBHelper.dbhelper
        .findNotes(widget.text)
        .then((List<Note> value) => notesList = value);
  }

  @override
  void initState() {
    getNotesData();
    getCategoryData();
    super.initState();
  }

  Future<void> getCategoryData() async {
    DBHelper.dbhelper
        .getAllCategories()
        .then((List<Category> value) => categoryList = value);
  }

  @override
  Widget build(BuildContext context) {
    if (!_finishGetDataNotes) {
      getNotesData().whenComplete(() {
        if (mounted) {
          _finishGetDataNotes = true;
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppRouter.route.replacmentRoute('/add-note');
        },
        backgroundColor: const Color(0xff796A41),
        child: const Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        backgroundColor: MyColor.appBarColor,
        actions: selectedIsRunning
            ? <Widget>[
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
                    deleteAlert(context);
                  },
                  tooltip: 'Delete',
                  icon: const Icon(
                    Icons.delete,
                    color: Color(0xffffffff),
                    size: 25,
                  ),
                ),
                popMenuItemsSelected()
              ]
            : <PopupMenuButton<int>>[
                popMenuItems(),
              ],
        title: selectedIsRunning ? Text('$count') : const Text('NotePad'),
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
                    tooltip: 'Menu',
                    icon: const Icon(
                      Icons.menu,
                      size: 25,
                      color: Color(0xffffffff),
                    )),
              ),
      ),
      drawer: selectedIsRunning ? null : MyDrawer(),
      backgroundColor: MyColor.backgroundScaffold,
      body: SingleChildScrollView(
        child: Column(
          children: notesList
              .asMap()
              .map((int i, Note e) {
                while (notesList.length > selectedNote.length) {
                  selectedNote.insert(0, false);
                }
                final List<String> categoryNumber = e.cat!.split(',');
                String categorySplittedString = "";
                categoryNumber.removeWhere((String element) => element == "");
                if (categoryNumber.length > 1) {
                  categorySplittedString =
                      categoryNumber[0] + "," + categoryNumber[1];
                  categorySplittedString += (categoryNumber.length - 3 >= 0)
                      ? (categorySplittedString.length > 30)
                          ? categorySplittedString.substring(0, 28) +
                              "..." +
                              "(+${categoryNumber.length - 2})"
                          : "(+${categoryNumber.length - 2})"
                      : "";
                } else {
                  categorySplittedString = e.cat!;
                }

                return MapEntry<int, Card>(
                  i,
                  Card(
                    elevation: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: Colors.black,
                        ),
                        gradient: selectedNote[i]
                            ? MyColor.containerColorWithSelected
                            : MyColor.containerColorWithoutSelected,
                      ),
                      child: ListTile(
                        title:
                            Text("${e.title! == "" ? "Untitled" : e.title!}"),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "$categorySplittedString",
                              style: const TextStyle(
                                  color: Color(0xff000000), fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 7),
                              child: Text(
                                "Last edit: ${DateFormat("d/M/yy, hh:mm a").format(DateTime.parse(e.dateEdition!))}",
                                style: const TextStyle(
                                    color: Color(0xff000000), fontSize: 13),
                              ),
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
                            print(e.dateCreation);
                            print(e.dateEdition);
                            AppRouter.route
                                .pushNamed('/add-note', <String, dynamic>{
                              'id': '${e.id}',
                              'title': '${e.title}',
                              'content': '${e.content}',
                              'dateEdition': '${e.dateEdition}',
                              'dateCreation': '${e.dateCreation}',
                            });
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
        const PopupMenuItem<int>(child: Text("Select all notes"), value: 0),
        const PopupMenuItem<int>(child: Text("Import Text Files"), value: 1),
        const PopupMenuItem<int>(
            child: Text("Export notes to text files"), value: 2),
      ],
      onSelected: (int value) {
        switch (value) {
          case 0:
            selectedIsRunning = true;
            for (int i = 0; i < selectedNote.length; i++) {
              selectedNote[i] = true;
            }
            count = selectedNote.length;
            setState(() {});
            break;
          case 1:
            break;
          case 2:
            break;
          default:
        }
      },
    );
  }

  Widget popMenuItemsSelected() {
    return PopupMenuButton<int>(
      child: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext bc) => <PopupMenuEntry<int>>[
        const PopupMenuItem<int>(
            child: Text("Export notes to text files"), value: 0),
        const PopupMenuItem<int>(child: Text("Categories"), value: 1),
      ],
      onSelected: (int value) {
        switch (value) {
          case 0:
            break;
          case 1:
            addCategoriesToNotes();
            break;

          default:
        }
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
          title: const Text('Select category'),
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
                                      const Divider(color: MyColor.textColor)
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
              onPressed: () {
                for (int i = 0; i < isCheck.length; i++) {
                  if (isCheck[i]) {
                    for (int j = 0; j < selectedNote.length; j++) {
                      if (selectedNote[j]) {
                        if (!notesList[j]
                            .cat!
                            .contains(categoryList[i].nameCat!)) {
                          notesList[j].cat = notesList[j].cat! +
                              categoryList[i].nameCat! +
                              ", ";
                        }
                      }
                    }
                  }
                }

                for (int i = 0; i < notesList.length; i++) {
                  if (selectedNote[i]) {
                    notesList[i].cat = notesList[i]
                        .cat!
                        .trimRight()
                        .substring(0, notesList[i].cat!.length - 1);
                    DBHelper.dbhelper.updateNote(notesList[i]);
                  }
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

  Future<void> deleteAlert(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Delete the selected notes?"),
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
                final int length = selectedNote.length;
                for (int i = length - 1; i >= 0; i--) {
                  if (selectedNote[i]) {
                    final Note deletedNote = Note.fromMap(notesList[i].toMap());
                    bool moveDeletedToTrash = SharedPreferenceHelper
                            .sharedPreference
                            .getBoolData("moveDeletedToTrash") ??
                        true;
                    if (moveDeletedToTrash) {
                      DBHelper.dbhelper.createDeletedNote(deletedNote);
                    }

                    selectedNote.removeAt(i);
                    DBHelper.dbhelper.deleteNote(notesList[i]);
                    notesList.removeAt(i);
                  }
                }
                count = 0;
                selectedIsRunning = false;
                setState(() {});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
