import 'package:flutter/material.dart';
import 'package:notepad/helper/toast_helper.dart';
import '../helper/db_helper.dart';
import '../helper/mycolor.dart';
import '../helper/file_helper.dart';
import '../widgets/my_drawer.dart';
import '../widgets/my_text.dart';

class BackUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Backup"),
        backgroundColor: MyColor.appBarColor,
      ),
      backgroundColor: MyColor.backgroundScaffold,
      drawer: MyDrawer(),
      body: Column(
        children: <Widget>[
          TextButton(
            onPressed: () {},
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: MyColor.appBarColor,
                ),
                gradient: MyColor.containerColorWithoutSelected,
              ),
              child: const Center(
                child: MyText("SHOW INSTRUCTIONS"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
                height: 280,
                width: double.infinity,
                decoration: MyColor.containerDercoration,
                child: Column(
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                          'A backup copy is a file containing copy of each note (except deleted notes in the "Trach" folder). it can be used to make copy of notes outside the device, or to transfer notes to another device. Categories are not included in a backup copy file.'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final String data =
                            await DBHelper.dbhelper.generateBackup();
                        FileHelper.files.writeInFile('backup', data);
                        ToastHelper.flutterToast("The backup was saved");
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                            color: MyColor.appBarColor,
                          ),
                          gradient: MyColor.containerColorWithoutSelected,
                        ),
                        child: const Center(
                          child: MyText("SAVE A BACKUP TO A FILE"),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final String backup =
                            await FileHelper.files.readFromFile('backup');
                        DBHelper.dbhelper.restoreBackup(backup);
                      },
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                            color: MyColor.appBarColor,
                          ),
                          gradient: MyColor.containerColorWithoutSelected,
                        ),
                        child: const Center(
                          child: MyText("LOAD NOTES FROM A BACKUP FILE"),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
