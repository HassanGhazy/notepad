import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notepad/helper/theme_helper.dart';
import 'package:notepad/provider/provider_note.dart';
import 'package:provider/provider.dart';
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
  String handleTheme =
      SharedPreferenceHelper.sharedPreference.getStringData("theme") ?? "1";

  ThemeData? theme;
  switch (handleTheme) {
    case "0":
      theme = ThemeHelper.lightTheme;
      break;
    case "1":
      theme = ThemeHelper.darkTheme;

      break;
    case "2":
      theme = ThemeHelper.systemSetting;

      break;
    default:
      theme = ThemeHelper.darkTheme;
  }
  MyColor.getColor();
  runApp(
    EasyLocalization(
        supportedLocales: [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: Locale('en'),
        child: ChangeNotifierProvider.value(
            value: ProviderNote(theme),
            builder: (_, child) => MyApp(_language))),
  );
}

class MyApp extends StatelessWidget {
  final int local;
  MyApp(this.local);
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ProviderNote>(context);
    return MaterialApp(
      theme: themeNotifier.getTheme(),
      title: 'Notepad'.tr(),
      debugShowCheckedModeBanner: false,
      home: Home(),
      // color: MyColor.appBarColor,
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
