import 'package:flutter/material.dart';
import 'package:notepad/helper/app_router.dart';
import 'package:notepad/helper/db_helper.dart';
import 'package:notepad/helper/mycolor.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/widgets/my_drawer.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<bool> selectedNote = <bool>[].toList();
  bool selectedIsRunning = false;
  int count = 0;
  List<Note> notesList = [];
  List<Note> tmpNotesList = []; // to use it in search
  bool _finishGetData = false;
  bool _enableSearch = false;
  bool _toggleSearchAndClose = false; //false => show search,true => show close
  final titleController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getNotesData();
  }

  Future<void> getNotesData() async {
    await DBHelper.dbhelper.getAllNotes().then((value) => notesList = value);
  }

  Future<void> optionsSort(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        int val = 2;
        int tmpVal = val;

        return AlertDialog(
          title: const Text('Sort By'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  children: <ListTile>[
                    ListTile(
                      title: Text("Edit date from oldest"),
                      onTap: () => setState(() => val = 1),
                      leading: Radio(
                        value: 1,
                        groupValue: val,
                        onChanged: (int? value) => setState(() => val = value!),
                      ),
                    ),
                    ListTile(
                      title: Text("Edit date from newest"),
                      onTap: () => setState(() => val = 2),
                      leading: Radio(
                        value: 2,
                        groupValue: val,
                        onChanged: (int? value) => setState(() => val = value!),
                      ),
                    ),
                    ListTile(
                      title: Text("Title: A to Z"),
                      onTap: () => setState(() => val = 3),
                      leading: Radio(
                        value: 3,
                        groupValue: val,
                        onChanged: (int? value) => setState(() => val = value!),
                      ),
                    ),
                    ListTile(
                      title: Text("Title: Z to A"),
                      onTap: () => setState(() => val = 4),
                      leading: Radio(
                        value: 4,
                        groupValue: val,
                        onChanged: (int? value) => setState(() => val = value!),
                      ),
                    ),
                    ListTile(
                      title: Text("Creation date from oldest"),
                      onTap: () => setState(() => val = 5),
                      leading: Radio(
                        value: 5,
                        groupValue: val,
                        onChanged: (int? value) => setState(() => val = value!),
                      ),
                    ),
                    ListTile(
                      title: Text("Creation date from newest"),
                      onTap: () => setState(() => val = 6),
                      leading: Radio(
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
              child: const Text('Cancel'),
              onPressed: () {
                val = tmpVal;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sort'),
              onPressed: () {
                switch (val) {
                  case 1:
                    Comparator<Note> ascendingDateEdition =
                        (a, b) => a.dateEdition!.compareTo(b.dateEdition!);
                    notesList = notesList..sort(ascendingDateEdition);
                    break;
                  case 2:
                    Comparator<Note> descendingDateEdition =
                        (b, a) => a.dateEdition!.compareTo(b.dateEdition!);
                    notesList = notesList..sort(descendingDateEdition);
                    break;
                  case 3:
                    Comparator<Note> ascendingTitle =
                        (a, b) => a.title!.compareTo(b.title!);
                    notesList = notesList..sort(ascendingTitle);
                    break;
                  case 4:
                    Comparator<Note> descendingTitle =
                        (b, a) => a.title!.compareTo(b.title!);
                    notesList = notesList..sort(descendingTitle);
                    break;
                  case 5:
                    Comparator<Note> ascendingDateCreation =
                        (a, b) => a.dateCreation!.compareTo(b.dateCreation!);
                    notesList = notesList..sort(ascendingDateCreation);
                    break;
                  case 6:
                    Comparator<Note> descendingDateCreation =
                        (b, a) => a.dateCreation!.compareTo(b.dateCreation!);
                    notesList = notesList..sort(descendingDateCreation);
                    break;
                }
                setState(() {});
                val = tmpVal;
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
    if (!_finishGetData) {
      getNotesData().whenComplete(() {
        if (!mounted) return;
        _finishGetData = true;
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
                IconButton(
                  onPressed: () {},
                  tooltip: 'More Vert',
                  icon: const Icon(
                    Icons.more_vert,
                    color: Color(0xffffffff),
                    size: 25,
                  ),
                ),
              ]
            : [
                _enableSearch
                    ? Container()
                    : TextButton(
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
                    style:
                        TextStyle(fontSize: 18, color: const Color(0xffffffff)),
                  ),
                ),
                popMenuItems(),
              ],
        title: selectedIsRunning
            ? Text('$count')
            : _enableSearch
                ? searchWidet()
                : Text('NotePad'),
        leading: selectedIsRunning || _enableSearch
            ? IconButton(
                onPressed: () {
                  _enableSearch = false;
                  if (tmpNotesList.isNotEmpty) notesList = tmpNotesList;
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
      backgroundColor: MyColor.backgroundScaffold,
      drawer: selectedIsRunning ? null : MyDrawer(),
      body: !_finishGetData
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: notesList
                    .asMap()
                    .map((i, e) {
                      while (notesList.length > selectedNote.length) {
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
                                // for (var i = 0; i < selected.length; i++) {
                                //   if (!selected[i]) count++;
                                //   if (selected[i]) {
                                //     selectedIsRunning = true;
                                //     break;
                                //   }
                                // }

                                // if (count == selected.length) {
                                //   selectedIsRunning = false;
                                // }

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

  TextField searchWidet() {
    return TextField(
      autofocus: true,
      cursorColor: Color(0xff444444),
      controller: titleController,
      decoration: InputDecoration(
        hintStyle: TextStyle(color: const Color(0xFFffffff)),
        suffixIcon: _toggleSearchAndClose
            ? IconButton(
                icon: Icon(Icons.close),
                color: Color(0xff444444),
                onPressed: () {
                  if (tmpNotesList.isNotEmpty) notesList = tmpNotesList;
                  titleController.clear();
                  setState(() {});
                },
              )
            : Icon(
                Icons.search,
                color: Color(0xff444444),
              ),
        focusColor: Color(0xff),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xff)),
        ),
      ),
      onChanged: (value) {
        if (value.isEmpty) {
          _toggleSearchAndClose = false;
        } else {
          _toggleSearchAndClose = true;
        }
        if (notesList.isNotEmpty) {
          if (notesList.any((element) =>
              element.title!.toLowerCase().contains(value.toLowerCase()))) {
            if (tmpNotesList.length < notesList.length) {
              tmpNotesList = notesList;
            }

            notesList = tmpNotesList;
            notesList = notesList
                .where((element) =>
                    element.title!.toLowerCase().contains(value.toLowerCase()))
                .toList();
            setState(() {});
          }
        }
      },
    );
  }
}
