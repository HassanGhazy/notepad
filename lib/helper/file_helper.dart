import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileHelper {
  FileHelper._();
  static FileHelper files = FileHelper._();
  Future<void> writeInFile(String fileName, String data) async {
    final PermissionStatus status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    final Directory? directory = await getExternalStorageDirectory();
    final String filePath = directory!.path + '/$fileName.txt';
    final File file = File(filePath);
    file.writeAsString(data);
  }

  Future<String> readFromFile(String fileName) async {
    final Directory? directory = await getExternalStorageDirectory();
    final String filePath = directory!.path + '/$fileName.txt';
    final File file = File(filePath);
    final String fileContent = await file.readAsString();
    return fileContent;
  }
}
