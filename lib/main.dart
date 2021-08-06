import 'package:flutter/material.dart';
import '../helper/mycolor.dart';
import '../screens/setting.dart';
import '../helper/shared_preference_helper.dart';
import '../screens/backup.dart';
import '../screens/one_category_notes_screen.dart';
import '../screens/trach_screen.dart';
import '../helper/db_helper.dart';
import '../helper/app_router.dart';
import '../screens/category_screen.dart';
import '../screens/note_screen.dart';
import '../screens/home.dart';

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
      title: 'Notepad',
      debugShowCheckedModeBanner: false,
      home: Home(),
      color: MyColor.appBarColor,
      navigatorKey: AppRouter.route.navKey,
      routes: {
        '/home': (_) => Home(),
        '/add-note': (_) => NoteScreen(),
        '/add-categorie': (_) => CategoryScreen(),
        '/backup': (_) => BackUp(),
        '/trash': (_) => TrashScreen(),
        '/one-category': (_) => const OneCategoryNotesScreen(""),
        '/setting': (_) => Setting(),
      },
    );
  }
}
