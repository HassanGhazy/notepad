import 'package:notepad/helper/db_helper.dart';
import 'package:notepad/models/Category.dart';

class Note {
  int? id;
  String? title;
  String? content;
  String? dateEdition;
  String? dateCreation;
  List<Category>? cat;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.dateEdition,
    this.dateCreation,
    this.cat,
  });

  toMap() {
    String allCat = "";
    this.cat!.forEach((e) {
      allCat += e.nameCat! + ", ";
    });
    if (allCat.length > 2) {
      allCat = allCat.trimRight().substring(2);
    }
    return {
      DBHelper.idColumnName: this.id,
      DBHelper.titleColumnName: this.title,
      DBHelper.contentColumnName: this.content,
      DBHelper.dateEditionColumnName: this.dateEdition,
      DBHelper.dateCreationColumnName: this.dateCreation,
      DBHelper.catColumnName: allCat,
    };
  }

  Note.fromMap(Map map) {
    List<Category> cat = [Category(nameCat: map[DBHelper.catColumnName])];
    this.id = map[DBHelper.idColumnName];
    this.title = map[DBHelper.titleColumnName];
    this.content = map[DBHelper.contentColumnName];
    this.dateEdition = map[DBHelper.dateEditionColumnName];
    this.dateCreation = map[DBHelper.dateCreationColumnName];
    this.cat = cat;
  }
}
