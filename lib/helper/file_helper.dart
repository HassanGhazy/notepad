import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  FileHelper._();
  static FileHelper files = FileHelper._();
  writeInFile(String fileName, String data) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = directory.path + '/$fileName.text';
    File file = File(filePath);
    file.writeAsString(data);
  }

  Future<String> readFromFile(String fileName) async {
    Directory directory = await getApplicationDocumentsDirectory();
    String filePath = directory.path + '/$fileName.text';
    File file = File(filePath);
    String fileContent = await file.readAsString();
    return fileContent;
  }
}
