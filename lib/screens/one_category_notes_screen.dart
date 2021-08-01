import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notepad/helper/app_router.dart';
import 'package:notepad/helper/db_helper.dart';
import 'package:notepad/helper/mycolor.dart';
import 'package:notepad/models/Category.dart';
import 'package:notepad/models/deletedNote.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/widgets/my_drawer.dart';

class OneCategoryNotesScreen extends StatefulWidget {
  final String text;
  OneCategoryNotesScreen(this.text);
  @override
  _OneCategoryNotesScreenState createState() => _OneCategoryNotesScreenState();
}

class _OneCategoryNotesScreenState extends State<OneCategoryNotesScreen> {
  List<Note> notesList = [];
  List<bool> selectedNote = <bool>[].toList();
  bool selectedIsRunning = false;
  int count = 0;
  List<Category> categoryList = [];
  bool _finishGetDataCategories = false;
  bool _finishGetDataNotes = false;
  Future<void> getNotesData() async {
    DBHelper.dbhelper.findNotes(widget.text).then((value) => notesList = value);
  }

  @override
  void initState() {
    getNotesData();
    getCategoryData();
    super.initState();
  }

  Future<void> getCategoryData() async {
    DBHelper.dbhelper.getAllCategories().then((value) => categoryList = value);
  }

  @override
  Widget build(BuildContext context) {
    if (!_finishGetDataNotes) {
      getNotesData().whenComplete(() {
        if (!mounted) return;
        _finishGetDataNotes = true;
        setState(() {});
      });
    }
    if (!_finishGetDataCategories) {
      getCategoryData().whenComplete(() {
        if (!mounted) return;
        _finishGetDataCategories = true;

        setState(() {});
      });
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppRouter.route.replacmentRoute('/add-note');
        },
        backgroundColor: Color(0xff796A41),
        child: const Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
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
            : [
                popMenuItems(),
              ],
        title: selectedIsRunning ? Text('$count') : Text('NotePad'),
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
      drawer: selectedIsRunning ? null : MyDrawer(),
      backgroundColor: MyColor.backgroundScaffold,
      body: SingleChildScrollView(
        child: Column(
          children: notesList
              .asMap()
              .map((i, e) {
                while (notesList.length > selectedNote.length) {
                  selectedNote.insert(0, false);
                }
                List<String> categoryNumber = e.cat!.split(',');
                String categorySplittedString = "";
                categoryNumber.removeWhere((element) => element == "");
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

                return MapEntry(
                  i,
                  Card(
                    elevation: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: new BorderRadius.all(Radius.circular(10)),
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
                          children: [
                            Text(
                              "$categorySplittedString",
                              style: TextStyle(
                                  color: Color(0xff000000), fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 7),
                              child: Text(
                                "Last edit: ${DateFormat("d/M/yy, hh:mm a").format(DateTime.parse(e.dateEdition!))}",
                                style: TextStyle(
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
                            AppRouter.route.pushNamed('/add-note', {
                              'id': '${e.id}',
                              'title': '${e.title}',
                              'content': '${e.content}',
                              'dateUpdate': '${e.dateEdition}',
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
    return PopupMenuButton(
      child: Icon(Icons.more_vert),
      itemBuilder: (BuildContext bc) => [
        PopupMenuItem(child: Text("Select all notes"), value: 0),
        PopupMenuItem(child: Text("Import Text Files"), value: 1),
        PopupMenuItem(child: Text("Export notes to text files"), value: 2),
      ],
      onSelected: (value) {
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
    return PopupMenuButton(
      child: Icon(Icons.more_vert),
      itemBuilder: (BuildContext bc) => [
        PopupMenuItem(child: Text("Export notes to text files"), value: 0),
        PopupMenuItem(child: Text("Categories"), value: 1),
      ],
      onSelected: (value) {
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
        isCheck = List.filled(categoryList.length, false);
        return AlertDialog(
          title: const Text('Select category'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return !_finishGetDataCategories
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      child: Column(
                        children: categoryList
                            .asMap()
                            .map(
                              (i, e) {
                                return MapEntry(
                                  i,
                                  Column(
                                    children: [
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
          content: Text("Delete the selected notes?"),
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
                int length = selectedNote.length;
                for (int i = length - 1; i >= 0; i--) {
                  if (selectedNote[i]) {
                    DeletedNote deletedNote =
                        DeletedNote.fromMap(notesList[i].toMap());

                    DBHelper.dbhelper.createDeletedNote(deletedNote);

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
