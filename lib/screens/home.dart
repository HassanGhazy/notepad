import 'package:flutter/material.dart';
import 'package:notepad/helper/app_router.dart';
import 'package:notepad/helper/db_helper.dart';
import 'package:notepad/models/note.dart';
import 'package:notepad/widgets/my_drawer.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<bool> selected = [];
  bool selectedIsRunning = false;
  int count = 0;
  List<Note> notesList = [];
  List<Note> tmpNotesList = [];
  bool _finishGetData = false;
  bool _enableSearch = false;
  bool _toggleSearchAndClose = false; //false => show search,true => show close

  final titleController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getNotesData();
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  Future<void> getNotesData() async {
    await DBHelper.dbhelper.getAllNotes().then((value) => notesList = value);
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
        backgroundColor: Color(0xff937654),
        actions: selectedIsRunning
            ? [
                IconButton(
                  tooltip: 'Select all the notes',
                  onPressed: () {
                    for (int i = 0; i < selected.length; i++) {
                      selected[i] = true;
                    }
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.select_all,
                    color: Color(0xffffffff),
                    size: 25,
                  ),
                ),
                IconButton(
                  onPressed: () {},
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
                  onPressed: () {},
                  child: const Text(
                    'Sort',
                    style:
                        TextStyle(fontSize: 18, color: const Color(0xffffffff)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    selectedIsRunning = false;
                    for (int i = 0; i < selected.length; i++) {
                      selected[i] = false;
                    }
                    setState(() {});
                  },
                  child: const Icon(
                    Icons.more_vert,
                    color: const Color(0xffffffff),
                    size: 25,
                  ),
                ),
              ],
        title: selectedIsRunning
            ? Text('$count')
            : _enableSearch
                ? TextField(
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
                                titleController.clear();
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
                        if (notesList.any((element) => element.title!
                            .toLowerCase()
                            .contains(value.toLowerCase()))) {
                          if (tmpNotesList.length < notesList.length) {
                            tmpNotesList = notesList;
                          }

                          notesList = tmpNotesList;
                          notesList = notesList
                              .where((element) => element.title!
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                          setState(() {});
                        }
                      }
                    },
                  )
                : Text('NotePad'),
        leading: selectedIsRunning || _enableSearch
            ? IconButton(
                onPressed: () {
                  _enableSearch = false;
                  if (tmpNotesList.isNotEmpty) notesList = tmpNotesList;
                  selectedIsRunning = false;
                  selected = List.filled(selected.length, false);
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
      backgroundColor: Color(0xffFFFFDD),
      drawer: selectedIsRunning ? null : MyDrawer(),
      body: notesList.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: notesList
                    .asMap()
                    .map((i, e) {
                      while (notesList.length > selected.length) {
                        selected.insert(0, false);
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
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: selected[i]
                                    ? [
                                        const Color(0xFFFBF6D6),
                                        const Color(0xFFBB9E80),
                                      ]
                                    : [
                                        const Color(0xFFFAFCCD),
                                        const Color(0xFFFEFBCE),
                                      ],
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                  "${e.title! == "" ? "Untitled" : e.title!}"),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "Last edit: ${DateFormat("d/M/yy, hh:mm a").format(DateTime.parse(e.date!))}",
                                    style: TextStyle(color: Color(0xff000000)),
                                  ),
                                ],
                              ),
                              onTap: () {
                                for (var i = 0; i < selected.length; i++) {
                                  if (!selected[i]) count++;
                                  if (selected[i]) {
                                    selectedIsRunning = true;
                                    break;
                                  }
                                }

                                if (count == selected.length) {
                                  selectedIsRunning = false;
                                }
                                if (selectedIsRunning) {
                                  selected[i] = !selected[i];
                                  if (selected[i]) {
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
                                    'dateUpdate': '${e.date}',
                                  });
                                }
                              },
                              onLongPress: () {
                                selectedIsRunning = true;
                                selected[i] = !selected[i];
                                if (selected[i]) {
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
}
