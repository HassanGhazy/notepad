import 'package:notepad/helper/db_helper.dart';
import 'package:notepad/models/Category.dart';

class Note {
  int? id;
  String? title;
  String? content;
  String? date;
  List<Category>? cat;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.date,
    this.cat,
  });

  toMap() {
    return {
      DBHelper.idColumnName: this.id,
      DBHelper.titleColumnName: this.title,
      DBHelper.contentColumnName: this.content,
      DBHelper.dateColumnName: this.date,
      DBHelper.catColumnName: this.cat,
    };
  }

  Note.fromMap(Map map) {
    this.id = map[DBHelper.idColumnName];
    this.title = map[DBHelper.titleColumnName];
    this.content = map[DBHelper.contentColumnName];
    this.date = map[DBHelper.dateColumnName];
    this.cat = map[DBHelper.catColumnName];
  }
}
