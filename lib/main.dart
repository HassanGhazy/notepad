import 'package:easy_localization/easy_localization.dart';
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
  await EasyLocalization.ensureInitialized();
  int _language =
      SharedPreferenceHelper.sharedPreference.getIntData("language") ?? 1;

  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: MyApp(_language)),
  );
}

class MyApp extends StatelessWidget {
  final int local;
  MyApp(this.local);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notepad'.tr(),
      debugShowCheckedModeBanner: false,
      home: Home(),
      color: MyColor.appBarColor,
      navigatorKey: AppRouter.route.navKey,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: const <Locale>[Locale('en'), Locale('ar')],
      locale: context.locale,
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
