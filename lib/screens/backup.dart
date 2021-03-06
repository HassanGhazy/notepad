import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../helper/toast_helper.dart';
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
        title: const Text("Backup").tr(),
        // backgroundColor: MyColor.appBarColor,
      ),
      // backgroundColor: MyColor.backgroundScaffold,
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
                    // color: MyColor.appBarColor,
                    ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    MyColor.linear1WithoutSelected,
                    MyColor.linear1WithoutSelected,
                  ],
                ),
              ),
              child: Center(
                child: MyText("SHOW INSTRUCTIONS".tr()),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(3),
            child: Container(
                height: 280,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  border: Border.all(
                      // color: appBarColor,
                      ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: <Color>[
                      MyColor.linear1WithoutSelected,
                      MyColor.linear1WithoutSelected,
                    ],
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                              'A backup copy is a file containing copy of each note (except deleted notes in the "Trach" folder). it can be used to make copy of notes outside the device, or to transfer notes to another device. Categories are not included in a backup copy file.')
                          .tr(),
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
                              // color: MyColor.appBarColor,
                              ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              MyColor.linear1WithoutSelected,
                              MyColor.linear1WithoutSelected,
                            ],
                          ),
                        ),
                        child: Center(
                          child: MyText("SAVE A BACKUP TO A FILE".tr()),
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
                              // color: MyColor.appBarColor,
                              ),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              MyColor.linear1WithoutSelected,
                              MyColor.linear1WithoutSelected,
                            ],
                          ),
                        ),
                        child: Center(
                          child: MyText("LOAD NOTES FROM A BACKUP FILE".tr()),
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
