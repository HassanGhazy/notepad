import 'package:flutter/material.dart';

class DetailNote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String?, String?> data =
        ModalRoute.of(context)!.settings.arguments as Map<String?, String?>;
    return Scaffold(
      appBar: AppBar(
        title: Text('${data['title']}'),
      ),
    );
  }
}
