import 'package:flutter/material.dart';
import 'package:notepad/helper/app_router.dart';
import 'package:notepad/screens/add_category.dart';
import 'package:notepad/screens/note_detail.dart';
import '../screens/add_note.dart';
import './screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NotePad',
      debugShowCheckedModeBanner: false,
      home: Home(),
      navigatorKey: AppRouter.route.navKey,
      routes: {
        '/home': (ctx) => Home(),
        '/add-note': (ctx) => AddNote(),
        '/detail-note': (ctx) => DetailNote(),
        '/add-categorie': (ctx) => AddCategory(),
      },
    );
  }
}
