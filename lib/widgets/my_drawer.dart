import 'package:flutter/material.dart';
import 'package:notepad/helper/app_router.dart';
import 'package:notepad/helper/db_helper.dart';
import 'package:notepad/helper/mycolor.dart';
import 'package:notepad/models/Category.dart';
import 'package:notepad/screens/one_category_notes_screen.dart';
import 'package:notepad/widgets/my_text.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  List<Category> categoryList = [];
  bool _finishGetData = false;

  @override
  void initState() {
    super.initState();
    getCategoryData();
  }

  Future<void> getCategoryData() async {
    DBHelper.dbhelper.getAllCategories().then((value) => categoryList = value);
  }

  @override
  Widget build(BuildContext context) {
    if (!_finishGetData) {
      getCategoryData().whenComplete(() {
        if (!mounted) return;
        _finishGetData = true;
        setState(() {});
      });
    }
    return Drawer(
      child: Container(
        color: const Color(0xffFFFFDD),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 50,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    "NotePad",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffffffff)),
                  ),
                ),
                color: const Color(0xff927855),
              ),
              ListTile(
                title: MyText("Notes"),
                leading: Icon(Icons.note),
                onTap: () {
                  if (ModalRoute.of(context)!.settings.name == '/' ||
                      ModalRoute.of(context)!.settings.name == '/home') {
                    Navigator.of(context).pop();
                  } else {
                    AppRouter.route.replacmentRoute('/home');
                  }
                },
              ),
              Divider(
                color: MyColor.middleLineDrawer,
                thickness: 2,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Categories",
                      style: TextStyle(color: const Color(0xff777777)),
                    )),
              ),
              Column(
                children: categoryList
                    .map((e) => ListTile(
                          title: Text(e.nameCat!),
                          leading: Icon(
                            Icons.label,
                            color: const Color(0xff747565),
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
              ListTile(
                title: MyText("Edit Categories"),
                leading: Icon(Icons.playlist_add),
                onTap: () {
                  if (ModalRoute.of(context)!.settings.name ==
                      '/add-categorie') {
                    Navigator.of(context).pop();
                  } else {
                    AppRouter.route.replacmentRoute('/add-categorie');
                  }
                },
              ),
              Divider(
                color: MyColor.middleLineDrawer,
                thickness: 2,
              ),
              ListTile(
                title: MyText("Backup"),
                leading: Icon(Icons.storage),
                onTap: () {
                  if (ModalRoute.of(context)!.settings.name == '/backup') {
                    Navigator.of(context).pop();
                  } else {
                    AppRouter.route.replacmentRoute('/backup');
                  }
                },
              ),
              ListTile(
                title: MyText("Trash"),
                leading: Icon(Icons.delete),
                onTap: () {
                  if (ModalRoute.of(context)!.settings.name == '/trash') {
                    Navigator.of(context).pop();
                  } else {
                    AppRouter.route.replacmentRoute('/trash');
                  }
                },
              ),
              Divider(
                color: MyColor.middleLineDrawer,
                thickness: 2,
              ),
              ListTile(
                title: MyText("Setting"),
                leading: Icon(Icons.settings),
                onTap: () {},
              ),
              ListTile(
                title: MyText("Rate The App"),
                leading: Icon(Icons.rate_review),
                onTap: () {},
              ),
              ListTile(
                title: MyText("Help"),
                leading: Icon(Icons.help),
                onTap: () {},
              ),
              ListTile(
                title: MyText("Privacy Policy"),
                leading: Icon(Icons.collections),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
