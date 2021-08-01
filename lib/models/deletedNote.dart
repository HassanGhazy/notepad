import 'package:notepad/helper/db_helper.dart';

class DeletedNote {
  int? id;
  String? title;
  String? content;
  String? dateEdition;
  String? dateCreation;
  String? cat;

  DeletedNote({
    required this.id,
    required this.title,
    required this.content,
    required this.dateEdition,
    required this.dateCreation,
    this.cat,
  });

  toMap() {
    return {
      DBHelper.idColumnName: this.id,
      DBHelper.titleColumnName: this.title,
      DBHelper.contentColumnName: this.content,
      DBHelper.dateEditionColumnName: this.dateEdition,
      DBHelper.dateCreationColumnName: this.dateCreation,
      DBHelper.catColumnName: this.cat,
    };
  }

  DeletedNote.fromMap(Map map) {
    this.id = map[DBHelper.idColumnName];
    this.title = map[DBHelper.titleColumnName];
    this.content = map[DBHelper.contentColumnName];
    this.dateEdition = map[DBHelper.dateEditionColumnName];
    this.dateCreation = map[DBHelper.dateCreationColumnName];
    this.cat = map[DBHelper.catColumnName];
  }
}
