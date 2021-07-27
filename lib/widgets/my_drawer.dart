import 'package:flutter/material.dart';
import 'package:notepad/helper/app_router.dart';
import 'package:notepad/widgets/my_text.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Categories",
                      style: TextStyle(color: const Color(0xff777777)),
                    )),
              ),
              ListTile(
                title: MyText("Edit Categories"),
                leading: Icon(Icons.playlist_add),
                onTap: () {
                  AppRouter.route.replacmentRoute('/add-categorie');
                },
              ),
              Divider(),
              ListTile(
                title: MyText("Backup"),
                leading: Icon(Icons.storage),
                onTap: () {},
              ),
              ListTile(
                title: MyText("Trash"),
                leading: Icon(Icons.delete),
                onTap: () {},
              ),
              Divider(),
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
