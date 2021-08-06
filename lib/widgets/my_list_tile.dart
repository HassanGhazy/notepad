import 'package:flutter/material.dart';
import 'my_text.dart';

import '../helper/app_router.dart';

class MyListTile extends StatelessWidget {
  MyListTile(this.title, this.icon, this.routeName);

  final String? title;
  final IconData? icon;
  final String? routeName;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: MyText(title!),
      leading: Icon(icon!),
      onTap: () {
        if (ModalRoute.of(context)!.settings.name == routeName!) {
          Navigator.of(context).pop();
        } else {
          AppRouter.route.replacmentRoute(routeName!);
        }
      },
    );
  }
}
