import 'dart:io';

import 'package:sqflite/sqflite.dart';

import '../models/Category.dart';
import '../models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBHelper {
  DBHelper._();
  static DBHelper dbhelper = DBHelper._();
  Database? database;
  static const idColumnName = 'id';
  static const nameCatColumnName = 'nameCat';
  static const titleColumnName = 'title';
  static const contentColumnName = 'content';
  static const dateColumnName = 'date';
  static const catColumnName = 'cat';
  static const tableNameNote = 'Note';
  static const tableNameCategory = 'Category';
  static const databaseName = 'notes.db';
  Future<void> initDataBase() async {
    database = await getDatabase();
  }

  Future<Database> getDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = join(directory.path, databaseName);
    Database databases = await openDatabase(
      filePath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            '''create table Note (id INTEGER primary key autoincrement, title Text, content Text, date Text , cat Text )''');
        db.execute(
            '''create table Category (id INTEGER primary key autoincrement, nameCat Text)''');
      },
    );
    return databases;
  }

  Future<void> createNote(Note note) async {
    await database?.insert(tableNameNote, note.toMap());
  }

  Future<void> createCategory(Category category) async {
    await database?.insert(tableNameCategory, category.toMap());
  }

  Future<List<Note>> getAllNotes() async {
    List<Map<String?, Object?>> res = await database!.query(tableNameNote);
    List<Note> notes = res.map((e) => Note.fromMap(e)).toList();
    return notes;
  }

  Future<List<Category>> getAllCategories() async {
    List<Map<String, Object?>> res = await database!.query(tableNameCategory);
    List<Category> categories = res.map((e) => Category.fromMap(e)).toList();
    return categories;
  }

  Future<void> deleteCategory(Category cat) async {
    if (cat.idCat == null) {
      await database?.delete(tableNameCategory,
          where: 'nameCat=?', whereArgs: ['${cat.nameCat}']);
    } else {
      await database?.delete(tableNameCategory,
          where: 'id=?', whereArgs: ['${cat.idCat}']);
    }
  }

  Future<void> deleteNote(Note note) async {
    await database
        ?.delete(tableNameNote, where: 'id=?', whereArgs: ['${note.id}']);
  }

  Future<void> updateNote(Note note) async {
    await database?.update(tableNameNote, note.toMap(),
        where: 'id=?', whereArgs: [note.id]);
  }

  Future<void> updateCategory(Category cat) async {
    await database?.update(tableNameCategory, cat.toMap(),
        where: 'id=?', whereArgs: [cat.idCat]);
  }
}
