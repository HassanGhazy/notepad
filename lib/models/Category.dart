import 'package:notepad/helper/db_helper.dart';

class Category {
  int? idCat;
  String? nameCat;
  Category({
    this.idCat,
    required this.nameCat,
  });

  toMap() {
    return {
      DBHelper.idColumnName: this.idCat,
      DBHelper.nameCatColumnName: this.nameCat,
    };
  }

  Category.fromMap(Map map) {
    this.idCat = map[DBHelper.idColumnName];
    this.nameCat = map[DBHelper.nameCatColumnName];
  }
}
