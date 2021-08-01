import 'package:flutter/material.dart';
import 'package:notepad/helper/app_router.dart';
import 'package:notepad/helper/db_helper.dart';
import 'package:notepad/models/note.dart';

class NoteScreen extends StatefulWidget {
  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _contentFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  bool _startWriting = false;
  List<Note> notesList = [];
  bool _finishGetData = false;
  bool _replaceContent = false;

  @override
  void initState() {
    super.initState();
    getNotesData();
  }

  Future<void> getNotesData() async {
    await DBHelper.dbhelper.getAllNotes().then((value) => notesList = value);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote(int id) {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }

    _form.currentState!.save();
    int i = notesList.indexWhere((e) => e.id == id);

    if (i != -1) {
      // this is a for update a exsit note
      Note note = Note(
          id: id,
          title: _titleController.text,
          content: _contentController.text,
          dateEdition: DateTime.now().toString());
      DBHelper.dbhelper.updateNote(note);

      for (int j = i; j > 0; j--) {
        Note tmpNote = notesList[j];
        notesList[j] = notesList[j - 1];
        notesList[j - 1] = tmpNote;
      }
    } else {
      // create new note
      Note note = Note(
        title: _titleController.text,
        content: _contentController.text,
        dateCreation: DateTime.now().toString(),
        dateEdition: DateTime.now().toString(),
        cat: [],
      );

      DBHelper.dbhelper.createNote(note);
      // noteProvider.addNewNote(note);

      setState(() {});
    }
    AppRouter.route.replacmentRoute('/home');
  }

  Map<String?, dynamic> data = {};
  int id = -1;
  String title = "";
  String content = "";
  @override
  Widget build(BuildContext context) {
    if (!_finishGetData) {
      getNotesData().whenComplete(() {
        if (!mounted) return;
        _finishGetData = true;
        setState(() {});
      });
    }
    if (ModalRoute.of(context)!.settings.arguments != null) {
      data =
          ModalRoute.of(context)!.settings.arguments as Map<String?, dynamic>;
      id = int.parse(data['id']);
      title = data['title'];
      content = data['content'];
      if (!_replaceContent) {
        _titleController.text = title;
        _contentController.text = content;
        _replaceContent = !_replaceContent;
      }
      setState(() {});
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("NotePad"),
        backgroundColor: Color(0xff907854),
        leading: IconButton(
            onPressed: () {
              AppRouter.route.replacmentRoute('/home');
            },
            icon: Icon(Icons.arrow_back)),
        actions: [
          TextButton(
            onPressed: () {
              if (id == -1) {
                _saveNote(-1);
              } else {
                _saveNote(id);
              }
            },
            child: Text(
              'Save',
              style: TextStyle(fontSize: 20, color: const Color(0xffffffff)),
            ),
          ),
          _contentController.text.length == 0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Undo',
                      style: TextStyle(
                        fontSize: 20,
                        color: const Color(0xffdddddd),
                      ),
                    ),
                  ),
                )
              : TextButton(
                  onPressed: () {
                    if (_contentController.text.length > 0) {
                      _contentController.text =
                          _contentController.text.trimRight();
                      _contentController.text = _contentController.text
                          .substring(0, _contentController.text.length - 1);
                      _contentController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _contentController.text.length));
                    }
                  },
                  child: Text(
                    'Undo',
                    style:
                        TextStyle(fontSize: 20, color: const Color(0xffffffff)),
                  ),
                ),
          TextButton(
            onPressed: () {},
            child: Icon(
              Icons.more_vert,
              color: const Color(0xffffffff),
              size: 30,
            ),
          ),
        ],
      ),
      backgroundColor: Color(0xffFDFCCE),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black38),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        ),
        child: Form(
          key: _form,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _titleController,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Enter title...',
                    hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_contentFocusNode);
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    showCursor: true,
                    focusNode: _contentFocusNode,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      if (value.isNotEmpty && !_startWriting) {
                        _startWriting = !_startWriting;
                        setState(() {});
                      }
                    },
                    minLines: 50,
                    controller: _contentController,
                    decoration: InputDecoration(
                      hintText: 'Enter text...',
                      hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
