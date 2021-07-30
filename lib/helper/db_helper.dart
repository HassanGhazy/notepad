import 'dart:io';

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
  static const idColumnName = 'id';
  static const nameCatColumnName = 'nameCat';
  static const titleColumnName = 'title';
  static const contentColumnName = 'content';
  static const dateEditionColumnName = 'dateEdition';
  static const dateCreationColumnName = 'dateCreation';
  static const catColumnName = 'cat';
  static const tableNameNote = 'Note';
  static const tableNameCategory = 'Category';
  static const databaseName = 'notes.db';
  static const SECRET_KEY = "KEY BACKUP HASAN";

  Future<void> initDataBase() async {
    database = await getDatabase();
  }

  Future<Database> getDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = join(directory.path, databaseName);
    Database databases = await openDatabase(
      filePath,
      version: 2,
      onCreate: (db, version) {
        db.execute(
            '''create table $tableNameNote ($idColumnName INTEGER primary key autoincrement, $titleColumnName Text, $contentColumnName Text, $dateEditionColumnName Text , $catColumnName Text ,$dateCreationColumnName Text)''');
        db.execute(
            '''create table $tableNameCategory ($idColumnName INTEGER primary key autoincrement, $nameCatColumnName Text)''');
      },
    );
    return databases;
  }

  Future<void> clearAllTables() async {
    try {
      var dbs = this.database;
      await dbs!.delete(tableNameNote);
      await dbs
          .rawQuery("DELETE FROM sqlite_sequence where name='$tableNameNote'");

      print('------ CLEAR ALL TABLE');
    } catch (e) {}
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

  Future<String> generateBackup({bool isEncrypted = true}) async {
    List<Map<String, dynamic>> listMaps = await database!.query(tableNameNote);

    String json = convert.jsonEncode(listMaps);

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
    Batch batch = database!.batch();

    var key = encrypt.Key.fromUtf8(SECRET_KEY);
    var iv = encrypt.IV.fromLength(16);
    var encrypter = encrypt.Encrypter(encrypt.AES(key));

    List<dynamic> json = convert
        .jsonDecode(isEncrypted ? encrypter.decrypt64(backup, iv: iv) : backup);

    for (int i = 0; i < json.length; i++) {
      batch.insert('$tableNameNote', json[i]);
    }
    await batch.commit(continueOnError: false, noResult: true);
  }
}
