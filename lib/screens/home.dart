import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:notepad/helper/toast_helper.dart';
import '../helper/file_helper.dart';
import '../helper/app_router.dart';
import '../helper/db_helper.dart';
import '../helper/mycolor.dart';
import '../helper/shared_preference_helper.dart';
import '../models/Category.dart';

import '../models/note.dart';
import '../widgets/my_drawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<bool> selectedNote = <bool>[].toList();
  bool selectedIsRunning = false;
  int count = 0;
  List<Note> notesList = <Note>[];
  List<Note> tmpNotesList = <Note>[]; // to use it in search
  bool _finishGetDataNotes = false;
  bool _enableSearch = false;
  bool _toggleSearchAndClose = false; //false => show search,true => show close
  final TextEditingController titleController = TextEditingController();
  List<Category> categoryList = <Category>[];
  bool _finishGetDataCategories = false;
  bool _showingCategories = true;

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _showingCategories = SharedPreferenceHelper.sharedPreference
            .getBoolData("showNoteCategory") ??
        false;
    getNotesData();
    getCategoryData();
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

  Future<void> optionsSort(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        int val =
            SharedPreferenceHelper.sharedPreference.getIntData('sortValue') ??
                2;

        return AlertDialog(
          title: const Text('Sort By').tr(),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: <ListTile>[
                    ListTile(
                      title: const Text("Edit date from oldest").tr(),
                      onTap: () => setState(() => val = 1),
                      leading: Radio<int>(
                        value: 1,
                        groupValue: val,
                        onChanged: (int? value) => setState(() => val = value!),
                      ),
                    ),
                    ListTile(
                      title: const Text("Edit date from newest").tr(),
                      onTap: () => setState(() => val = 2),
                      leading: Radio<int>(
                        value: 2,
                        groupValue: val,
                        onChanged: (int? value) => setState(() => val = value!),
                      ),
                    ),
                    ListTile(
                      title: const Text("Title: A to Z").tr(),
                      onTap: () => setState(() => val = 3),
                      leading: Radio<int>(
                        value: 3,
                        groupValue: val,
                        onChanged: (int? value) => setState(() => val = value!),
                      ),
                    ),
                    ListTile(
                      title: const Text("Title: Z to A").tr(),
                      onTap: () => setState(() => val = 4),
                      leading: Radio<int>(
                        value: 4,
                        groupValue: val,
                        onChanged: (int? value) => setState(() => val = value!),
                      ),
                    ),
                    ListTile(
                      title: const Text("Creation date from oldest").tr(),
                      onTap: () => setState(() => val = 5),
                      leading: Radio<int>(
                        value: 5,
                        groupValue: val,
                        onChanged: (int? value) => setState(() => val = value!),
                      ),
                    ),
                    ListTile(
                      title: const Text("Creation date from newest").tr(),
                      onTap: () => setState(() => val = 6),
                      leading: Radio<int>(
                        value: 6,
                        groupValue: val,
                        onChanged: (int? value) => setState(() => val = value!),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel').tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sort').tr(),
              onPressed: () {
                sortListMethod(val);
                setState(() {});

                SharedPreferenceHelper.sharedPreference
                    .saveIntData("sortValue", val);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void sortListMethod(int val) {
    switch (val) {
      case 1:
        final Comparator<Note> ascendingDateEdition =
            (Note a, Note b) => a.dateEdition!.compareTo(b.dateEdition!);
        notesList = notesList..sort(ascendingDateEdition);
        break;
      case 2:
        final Comparator<Note> descendingDateEdition =
            (Note b, Note a) => a.dateEdition!.compareTo(b.dateEdition!);
        notesList = notesList..sort(descendingDateEdition);
        break;
      case 3:
        final Comparator<Note> ascendingTitle =
            (Note a, Note b) => a.title!.compareTo(b.title!);
        notesList = notesList..sort(ascendingTitle);
        break;
      case 4:
        final Comparator<Note> descendingTitle =
            (Note b, Note a) => a.title!.compareTo(b.title!);
        notesList = notesList..sort(descendingTitle);
        break;
      case 5:
        final Comparator<Note> ascendingDateCreation =
            (Note a, Note b) => a.dateCreation!.compareTo(b.dateCreation!);
        notesList = notesList..sort(ascendingDateCreation);
        break;
      case 6:
        final Comparator<Note> descendingDateCreation =
            (Note b, Note a) => a.dateCreation!.compareTo(b.dateCreation!);
        notesList = notesList..sort(descendingDateCreation);
        break;
    }
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
                                      Divider(color: MyColor.textColor)
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

  Widget popMenuItemsSelected() {
    return PopupMenuButton<int>(
      child: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext bc) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(
            child: Text("Export notes to text files").tr(), value: 0),
        PopupMenuItem<int>(child: Text("Categories").tr(), value: 1),
      ],
      onSelected: (int value) {
        switch (value) {
          case 0:
            for (int i = 0; i < selectedNote.length; i++) {
              if (selectedNote[i]) {
                FileHelper.files.writeInFile(
                    notesList[i].title == ""
                        ? "Untitled".tr()
                        : notesList[i].title!,
                    notesList[i].title! + ":" + notesList[i].content!);
              }
            }
            ToastHelper.flutterToast("The file(s) was exported");
            break;
          case 1:
            addCategoriesToNotes();
            break;

          default:
        }
      },
    );
  }

  Future<void> deleteAlert(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text("Delete the selected notes?").tr(),
          actions: <TextButton>[
            TextButton(
              child: Text(
                'CANCEL',
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
              onPressed: () {
                bool moveDeletedToTrash = SharedPreferenceHelper
                        .sharedPreference
                        .getBoolData("moveDeletedToTrash") ??
                    true;
                final int length = selectedNote.length;
                for (int i = length - 1; i >= 0; i--) {
                  if (selectedNote[i]) {
                    if (moveDeletedToTrash) {
                      final Note deletedNote =
                          Note.fromMap(notesList[i].toMap());

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

  @override
  Widget build(BuildContext context) {
    if (!_finishGetDataNotes) {
      getNotesData().whenComplete(() {
        if (mounted) {
          _finishGetDataNotes = true;
          int val =
              SharedPreferenceHelper.sharedPreference.getIntData('sortValue') ??
                  2;
          sortListMethod(val);
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
                    color: Color(0xffffffff),
                    size: 25,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    deleteAlert(context);
                  },
                  tooltip: 'Delete'.tr(),
                  icon: const Icon(
                    Icons.delete,
                    color: Color(0xffffffff),
                    size: 25,
                  ),
                ),
                popMenuItemsSelected()
              ]
            : <Widget>[
                if (_enableSearch)
                  Container()
                else
                  TextButton(
                    onPressed: () {
                      _enableSearch = true;
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.search,
                      color: Color(0xffffffff),
                      size: 25,
                    ),
                  ),
                TextButton(
                  onPressed: () {
                    optionsSort(context);
                  },
                  child: const Text(
                    'Sort',
                    style: TextStyle(fontSize: 18, color: Color(0xffffffff)),
                  ).tr(),
                ),
                popMenuItems(),
              ],
        title: selectedIsRunning
            ? Text('$count')
            : _enableSearch
                ? searchWidet()
                : const Text('Notepad').tr(),
        leading: selectedIsRunning || _enableSearch
            ? IconButton(
                onPressed: () {
                  _enableSearch = false;
                  if (tmpNotesList.isNotEmpty) {
                    notesList = tmpNotesList;
                  }
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
                      color: Color(0xffffffff),
                    )),
              ),
      ),
      backgroundColor: MyColor.backgroundScaffold,
      drawer: selectedIsRunning ? null : MyDrawer(),
      body: !_finishGetDataNotes
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: notesList
                    .asMap()
                    .map((int i, Note e) {
                      while (notesList.length > selectedNote.length) {
                        selectedNote.insert(0, false);
                      }
                      final List<String> categoryNumber = e.cat!.split(',');
                      String categorySplittedString = "";
                      categoryNumber
                          .removeWhere((String element) => element == "");
                      if (categoryNumber.length > 1) {
                        categorySplittedString =
                            categoryNumber[0] + "," + categoryNumber[1];
                        categorySplittedString +=
                            (categoryNumber.length - 3 >= 0)
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
                              title: Text(
                                  "${e.title! == "" ? "Untitled".tr() : e.title!}"),
                              subtitle: !_showingCategories
                                  ? Container()
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text(
                                          "$categorySplittedString",
                                          style: const TextStyle(
                                              color: Color(0xff000000),
                                              fontSize: 13),
                                          textAlign: TextAlign.center,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 7),
                                          child: Text(
                                            "${"Last edit:".tr()}${DateFormat("d/M/yy, hh:mm a").format(DateTime.parse(e.dateEdition!))}",
                                            style: const TextStyle(
                                                color: Color(0xff000000),
                                                fontSize: 13),
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

  Widget popMenuItems() {
    return PopupMenuButton<int>(
      child: const Icon(Icons.more_vert),
      itemBuilder: (BuildContext bc) => <PopupMenuEntry<int>>[
        PopupMenuItem<int>(child: Text("Select all notes").tr(), value: 0),
        PopupMenuItem<int>(child: Text("Import Text Files").tr(), value: 1),
        PopupMenuItem<int>(
            child: Text("Export notes to text files").tr(), value: 2),
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
            for (int i = 0; i < notesList.length; i++) {
              FileHelper.files.writeInFile(
                  notesList[i].title == ""
                      ? "Untitled".tr()
                      : notesList[i].title!,
                  notesList[i].title! + ":" + notesList[i].content!);
            }
            ToastHelper.flutterToast("The file(s) was exported");
            break;
          default:
        }
      },
    );
  }

  TextField searchWidet() {
    return TextField(
      autofocus: true,
      cursorColor: const Color(0xff444444),
      controller: titleController,
      decoration: InputDecoration(
        hintStyle: const TextStyle(color: Color(0xFFffffff)),
        suffixIcon: _toggleSearchAndClose
            ? IconButton(
                icon: const Icon(Icons.close),
                color: const Color(0xff444444),
                onPressed: () {
                  if (tmpNotesList.isNotEmpty) {
                    notesList = tmpNotesList;
                  }
                  titleController.clear();
                  setState(() {});
                },
              )
            : const Icon(
                Icons.search,
                color: Color(0xff444444),
              ),
        focusColor: Colors.transparent,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
      onChanged: (String value) {
        if (value.isEmpty) {
          _toggleSearchAndClose = false;
        } else {
          _toggleSearchAndClose = true;
        }
        if (notesList.isNotEmpty) {
          if (notesList.any((Note element) =>
              element.title!.toLowerCase().contains(value.toLowerCase()))) {
            if (tmpNotesList.length < notesList.length) {
              tmpNotesList = notesList;
            }

            notesList = tmpNotesList;
            notesList = notesList
                .where((Note element) =>
                    element.title!.toLowerCase().contains(value.toLowerCase()))
                .toList();
            setState(() {});
          }
        }
      },
    );
  }
}
