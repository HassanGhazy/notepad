import 'package:flutter/material.dart';
import 'package:notepad/helper/shared_preference_helper.dart';
// import 'package:notepad/provider/note_provider.dart';
import 'package:notepad/screens/backup.dart';
import 'package:notepad/screens/one_category_notes_screen.dart';
import 'package:notepad/screens/trach_screen.dart';
// import 'package:provider/provider.dart';
import '../helper/db_helper.dart';
import '../helper/app_router.dart';
import 'screens/category_screen.dart';
import './screens/note_screen.dart';
import './screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.dbhelper.initDataBase();
  await SharedPreferenceHelper.sharedPreference.initSharedPreferences();
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
        '/backup': (ctx) => BackUp(),
        '/trash': (ctx) => TrashScreen(),
        '/one-category': (ctx) => OneCategoryNotesScreen(""),
      },
    );
  }
}
