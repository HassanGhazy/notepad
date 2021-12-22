import 'package:flutter/material.dart';
import 'package:notepad/helper/app_router.dart';
import 'package:easy_localization/easy_localization.dart';

class BackTextButton extends StatelessWidget {
  const BackTextButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text('CANCEL').tr(),
      onPressed: () {
        AppRouter.route.back();
      },
    );
  }
}