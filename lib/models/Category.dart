import '../helper/db_helper.dart';

class Category {
  Category({
    this.idCat,
    required this.nameCat,
  });
  Category.fromMap(Map<String, dynamic> map) {
    idCat = map[DBHelper.idColumnName] as int;
    nameCat = map[DBHelper.nameCatColumnName] as String;
  }
  int? idCat;
  String? nameCat;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      DBHelper.idColumnName: idCat,
      DBHelper.nameCatColumnName: nameCat,
    };
  }
}
