import 'dart:io';

import 'package:notepad/helper/toast_helper.dart';

import 'package:sqflite/sqflite.dart';

import '../models/Category.dart';
import '../models/note.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:convert' as convert;
import 'package:encrypt/encrypt.dart' as encrypt;

class DBHelper {
  DBHelper._();
  static DBHelper dbhelper = DBHelper._();
  Database? database;
  static const String idColumnName = 'id';
  static const String nameCatColumnName = 'nameCat';
  static const String titleColumnName = 'title';
  static const String contentColumnName = 'content';
  static const String dateEditionColumnName = 'dateEdition';
  static const String dateCreationColumnName = 'dateCreation';
  static const String catColumnName = 'cat';
  static const String tableNameNote = 'Note';
  static const String tableNameCategory = 'Category';
  static const String tableNameDeletedNote = 'DeletedNote';
  static const String databaseName = 'notes.db';
  static const String SECRET_KEY = "KEY BACKUP HASAN";

  Future<void> initDataBase() async {
    database = await getDatabase();
  }

  Future<Database> getDatabase() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = join(directory.path, databaseName);
    final Database databases = await openDatabase(
      filePath,
      version: 1,
      onCreate: (Database db, int version) {
        db.execute(
            '''create table $tableNameNote ($idColumnName INTEGER primary key autoincrement, $titleColumnName Text, $contentColumnName Text, $dateEditionColumnName Text , $catColumnName Text ,$dateCreationColumnName Text)''');
        db.execute(
            '''create table $tableNameCategory ($idColumnName INTEGER primary key autoincrement, $nameCatColumnName Text)''');
        db.execute(
            '''create table $tableNameDeletedNote ($idColumnName INTEGER primary key autoincrement, $titleColumnName Text, $contentColumnName Text, $dateEditionColumnName Text , $catColumnName Text ,$dateCreationColumnName Text)''');
      },
    );
    return databases;
  }

  Future<void> clearAllTables() async {
    try {
      final Database dbs = database!;
      await dbs.delete(tableNameNote);
      await dbs
          .rawQuery("DELETE FROM sqlite_sequence where name='$tableNameNote'");

      print('------ CLEAR ALL TABLE');
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createNote(Note note) async {
    await database?.insert(tableNameNote, note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> createCategory(Category category) async {
    await database?.insert(tableNameCategory, category.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> createDeletedNote(Note deletedNote) async {
    await database?.insert(tableNameDeletedNote, deletedNote.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Note>> getAllNotes() async {
    final List<Map<String?, Object?>> res =
        await database!.query(tableNameNote);
    final List<Note> notes = res.map((Map<String?, dynamic> e) {
      return Note.fromMap(e);
    }).toList();
    return notes;
  }

  Future<List<Note>> findNotes(String text) async {
    final List<Map<String?, dynamic>> res = await database!.rawQuery(
        "SELECT * FROM $tableNameNote WHERE $catColumnName LIKE '%$text%'");
    final List<Note> notes =
        res.map((Map<String?, dynamic> e) => Note.fromMap(e)).toList();
    return notes;
  }

  Future<List<Category>> getAllCategories() async {
    final List<Map<String, Object?>> res =
        await database!.query(tableNameCategory);
    final List<Category> categories =
        res.map((Map<String, dynamic> e) => Category.fromMap(e)).toList();
    return categories;
  }

  Future<List<Note>> getAllDeletedNotes() async {
    final List<Map<String?, Object?>> res =
        await database!.query(tableNameDeletedNote);
    final List<Note> deletedNote =
        res.map((Map<String?, dynamic> e) => Note.fromMap(e)).toList();
    return deletedNote;
  }

  Future<void> deleteCategory(Category cat) async {
    if (cat.idCat == null) {
      await database?.delete(tableNameCategory,
          where: 'nameCat=?', whereArgs: <Object>['${cat.nameCat}']);
    } else {
      await database?.delete(tableNameCategory,
          where: 'id=?', whereArgs: <Object>['${cat.idCat}']);
    }
  }

  Future<void> deleteNote(Note note) async {
    await database?.delete(tableNameNote,
        where: 'id=?', whereArgs: <Object>['${note.id}']);
  }

  Future<void> deleteNoteForever(Note deletedNote) async {
    await database?.delete(tableNameDeletedNote,
        where: 'id=?', whereArgs: <Object>['${deletedNote.id}']);
  }

  Future<void> updateNote(Note note) async {
    await database?.update(tableNameNote, note.toMap(),
        where: 'id=?', whereArgs: <int>[note.id!]);
  }

  Future<void> updateCategory(Category cat) async {
    await database?.update(tableNameCategory, cat.toMap(),
        where: 'id=?', whereArgs: <int>[cat.idCat!]);
  }

  Future<String> generateBackup({bool isEncrypted = true}) async {
    final List<Map<String, dynamic>> listMaps =
        await database!.query(tableNameNote);

    final String json = convert.jsonEncode(listMaps);

    if (isEncrypted) {
      var key = encrypt.Key.fromUtf8(SECRET_KEY);
      var iv = encrypt.IV.fromLength(16);
      var encrypter = encrypt.Encrypter(encrypt.AES(key));
      var encrypted = encrypter.encrypt(json, iv: iv);
      return encrypted.base64;
    } else {
      return json;
    }
  }

  Future<void> restoreBackup(String backup, {bool isEncrypted = true}) async {
    final Batch batch = database!.batch();

    var key = encrypt.Key.fromUtf8(SECRET_KEY);
    var iv = encrypt.IV.fromLength(16);
    var encrypter = encrypt.Encrypter(encrypt.AES(key));

    final List<dynamic> json = convert
        .jsonDecode(isEncrypted ? encrypter.decrypt64(backup, iv: iv) : backup);

    for (int i = 0; i < json.length; i++) {
      batch.insert('$tableNameNote', json[i]);
    }
    try {
      await batch.commit(continueOnError: false, noResult: true);
      ToastHelper.flutterToast("The data was restored");
    } catch (error) {
      if (error.toString().contains("UNIQUE constraint failed")) {
        ToastHelper.flutterToast("Some of data already exist");
      }
    }
  }
}
