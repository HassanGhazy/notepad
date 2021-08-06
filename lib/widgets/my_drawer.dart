import 'package:flutter/material.dart';
import 'package:notepad/widgets/my_list_tile.dart';
import 'package:notepad/helper/luncher_helper.dart';
import '../helper/app_router.dart';
import '../helper/db_helper.dart';
import '../helper/mycolor.dart';
import '../models/Category.dart';
import '../screens/one_category_notes_screen.dart';
import '../widgets/my_text.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  List<Category> categoryList = <Category>[];
  bool _finishGetData = false;

  @override
  void initState() {
    super.initState();
    getCategoryData();
  }

  Future<void> getCategoryData() async {
    DBHelper.dbhelper
        .getAllCategories()
        .then((List<Category> value) => categoryList = value);
  }

  @override
  Widget build(BuildContext context) {
    if (!_finishGetData) {
      getCategoryData().whenComplete(() {
        if (mounted) {
          _finishGetData = true;
          setState(() {});
        }
      });
    }
    return Drawer(
      child: Container(
        color: const Color(0xffFFFFDD),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 50,
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "NotePad",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffffffff)),
                  ),
                ),
                color: const Color(0xff927855),
              ),
              ListTile(
                title: const MyText("Notes"),
                leading: const Icon(Icons.note),
                onTap: () {
                  if (ModalRoute.of(context)!.settings.name == '/' ||
                      ModalRoute.of(context)!.settings.name == '/home') {
                    Navigator.of(context).pop();
                  } else {
                    AppRouter.route.replacmentRoute('/home');
                  }
                },
              ),
              const Divider(
                color: MyColor.middleLineDrawer,
                thickness: 2,
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Categories",
                      style: TextStyle(color: Color(0xff777777)),
                    )),
              ),
              Column(
                children: categoryList
                    .map((Category e) => ListTile(
                          title: Text(e.nameCat!),
                          leading: const Icon(
                            Icons.label,
                            color: Color(0xff747565),
                          ),
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    OneCategoryNotesScreen(e.nameCat!),
                              ),
                            );
                          },
                        ))
                    .toList(),
              ),
              MyListTile(
                  "Edit Categories", Icons.playlist_add, '/add-categorie'),
              const Divider(color: MyColor.middleLineDrawer, thickness: 2),
              MyListTile("Backup", Icons.storage, '/backup'),
              MyListTile("Trash", Icons.delete, '/trash'),
              const Divider(color: MyColor.middleLineDrawer, thickness: 2),
              MyListTile("Setting", Icons.settings, '/setting'),
              MyListTile("Rate The App", Icons.rate_review, '/'), // check route
              MyListTile("Help", Icons.help, '/'), // check route

              ListTile(
                title: const MyText("Privacy Policy"),
                leading: const Icon(Icons.copy_all),
                onTap: () {
                  LauncherHelper.launcher.openWebPage(
                      "https://docs.google.com/document/d/1Irv9J70PnafXkBnI-9E_XHMCI_3DfuEzqESLfgQ_DEY/edit?usp=sharing");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
