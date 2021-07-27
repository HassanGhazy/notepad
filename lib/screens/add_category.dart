import 'package:flutter/material.dart';
import 'package:notepad/widgets/my_drawer.dart';
import 'package:notepad/widgets/my_text.dart';

class AddCategory extends StatefulWidget {
  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final _titleCategoryController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleCategoryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        backgroundColor: Color(0xff907854),
      ),
      backgroundColor: Color(0xffFDFCCE),
      drawer: MyDrawer(),
      body: Form(
        key: _form,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _titleCategoryController,
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: 'New category name',
                        hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                    ),
                  ),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(25),
                      ),
                      border: Border.all(color: Color(0xff999999)),
                      gradient: LinearGradient(
                        colors: [Color(0xffFAFAC6), Color(0xffFAF4B6)],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          shadowColor: Colors.transparent),
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
