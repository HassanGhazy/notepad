import '../helper/db_helper.dart';

class Note {
  Note({
    this.id,
    required this.title,
    required this.content,
    required this.dateEdition,
    this.dateCreation,
    this.cat,
  });
  Note.fromMap(Map<String?, dynamic> map) {
    id = map[DBHelper.idColumnName] as int;
    title = map[DBHelper.titleColumnName] as String;
    content = map[DBHelper.contentColumnName] as String;
    dateEdition = map[DBHelper.dateEditionColumnName] as String;
    dateCreation = map[DBHelper.dateCreationColumnName] as String;
    cat = map[DBHelper.catColumnName] as String;
  }
  int? id;
  String? title;
  String? content;
  String? dateEdition;
  String? dateCreation;
  String? cat;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      DBHelper.idColumnName: id,
      DBHelper.titleColumnName: title,
      DBHelper.contentColumnName: content,
      DBHelper.dateEditionColumnName: dateEdition,
      DBHelper.dateCreationColumnName: dateCreation,
      DBHelper.catColumnName: cat,
    };
  }
}
