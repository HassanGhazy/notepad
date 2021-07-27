import 'package:flutter/material.dart';
import 'package:notepad/helper/app_router.dart';
import 'package:notepad/provider/note_procider.dart';
import 'package:notepad/widgets/my_drawer.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppRouter.route.pushNamed('/add-note', {});
        },
        backgroundColor: Color(0xff796A41),
        child: const Icon(
          Icons.add,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xff937654),
        actions: [
          TextButton(
            onPressed: () {},
            child: Icon(
              Icons.search,
              color: const Color(0xffffffff),
              size: 25,
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              'Sort',
              style: TextStyle(fontSize: 18, color: const Color(0xffffffff)),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Icon(
              Icons.more_vert,
              color: const Color(0xffffffff),
              size: 25,
            ),
          ),
        ],
        title: Text('NotePad'),
        leading: Builder(
          builder: (context) => IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: 'Menu',
              icon: Icon(
                Icons.menu,
                size: 25,
                color: Color(0xffffffff),
              )),
        ),
      ),
      backgroundColor: Color(0xffFFFFDD),
      drawer: MyDrawer(),
      body: ListView.builder(
        itemCount: NoteProvider().note.length,
        itemBuilder: (context, i) => Card(
          elevation: 0,
          child: Container(
            height: 70,
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.black),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFAFCCD),
                  const Color(0xFFFEFBCE),
                ],
              ),
            ),
            child: ListTile(
              title: Text(
                  "${NoteProvider().note[i].title == "" ? "Untitled" : NoteProvider().note[i].title}"),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Last edit: ${NoteProvider().note[i].dateUpdate}",
                    style: TextStyle(color: Color(0xff000000)),
                  ),
                ],
              ),
              onTap: () {
                AppRouter.route.pushNamed('DetailNote', {
                  'title': '${NoteProvider().note[i].title}',
                  'content': '${NoteProvider().note[i].content}'
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
