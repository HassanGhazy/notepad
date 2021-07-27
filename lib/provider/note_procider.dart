import 'package:notepad/models/Category.dart';
import 'package:notepad/models/note.dart';

class NoteProvider {
  List<Note> _note = [];
  List<Note> get note => [..._note];

  List<Category> _categories = [];
  List<Category> get categories => [..._categories];

  void addNewNote(String id, String title, String content, String dateCreate,
      String dateUpdate) {
    _note.add(
      new Note(
          id: id,
          title: title,
          content: content,
          dateCreate: dateCreate,
          dateUpdate: dateUpdate),
    );
  }

  void updateNote(
      String id, String title, String content, String lastEditDate) {
    Note note = _note.firstWhere((note) => note.id == id);
    // TODO
  }

  void deleteNote(String id) {
    int index = _note.indexWhere((note) => note.id == id);
    _note.removeAt(index);
  }

  void addNewCategory(String idCat, String nameCat) {
    _categories.add(
      new Category(
        idCat: idCat,
        nameCat: nameCat,
      ),
    );
  }

  void deleteCategory(String idCat) {
    int index = _categories.indexWhere((category) => category.idCat == idCat);
    _categories.removeAt(index);
  }
}
