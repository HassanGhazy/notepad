import 'package:flutter/material.dart';
import 'package:notepad/provider/note_procider.dart';

class AddNote extends StatefulWidget {
  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _contentFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  bool _startWriting = false;
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final isValid = _form.currentState!.validate();
    if (!isValid) {
      return;
    }
    _form.currentState!.save();
    NoteProvider().addNewNote(
        DateTime.now().toString(),
        _titleController.text,
        _contentController.text,
        DateTime.now().toString(),
        DateTime.now().toString());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("NotePad"),
        backgroundColor: Color(0xff907854),
        actions: [
          TextButton(
            onPressed: () {
              _saveNote();
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
