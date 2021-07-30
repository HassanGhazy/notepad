import 'package:flutter/material.dart';
import '../helper/db_helper.dart';
import '../helper/app_router.dart';
import 'screens/category_screen.dart';
import './screens/note_screen.dart';
import './screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.dbhelper.initDataBase();
  runApp(MyApp());
}

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
        '/add-note': (ctx) => NoteScreen(),
        '/add-categorie': (ctx) => CategoryScreen(),
      },
    );
  }
}
