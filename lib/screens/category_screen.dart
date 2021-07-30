import 'package:flutter/material.dart';
import '../helper/db_helper.dart';
import '../models/Category.dart';
import '../widgets/my_drawer.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _titleCategoryController = TextEditingController();
  final _changetitleCategoryController = TextEditingController();
  final _form = GlobalKey<FormState>();
  List<Category> categoryList = [];
  bool _finishGetData = false;
  @override
  void dispose() {
    _titleCategoryController.dispose();
    _changetitleCategoryController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getCategoryData();
  }

  Future<void> getCategoryData() async {
    DBHelper.dbhelper.getAllCategories().then((value) => categoryList = value);
  }

  Future<void> _showMyDialog(Category cat) async {
    _changetitleCategoryController.text = cat.nameCat!;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Categorie'),
          content: TextFormField(
            controller: _changetitleCategoryController,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'edit category name',
              hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () async {
                if (_changetitleCategoryController.text != "") {
                  int index = categoryList.indexOf(cat);
                  cat.nameCat = _changetitleCategoryController.text;
                  categoryList[index].nameCat =
                      _changetitleCategoryController.text;
                  await DBHelper.dbhelper.updateCategory(cat);

                  setState(() {});
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // final categoryProvider = Provider.of<NoteProvider>(context, listen: false);
    if (!_finishGetData) {
      getCategoryData().whenComplete(() {
        if (!mounted) return;
        _finishGetData = true;
        setState(() {});
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        backgroundColor: Color(0xff907854),
      ),
      backgroundColor: Color(0xffFDFCCE),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Container(
            height: 70,
            child: Form(
              key: _form,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _titleCategoryController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'New category name',
                          hintStyle:
                              TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          bool isNotExist = categoryList.every((element) =>
                              element.nameCat != _titleCategoryController.text);
                          if (_titleCategoryController.text.isNotEmpty &&
                              isNotExist) {
                            Category category = Category(
                                nameCat: _titleCategoryController.text);
                            DBHelper.dbhelper.createCategory(category);
                            _titleCategoryController.clear();

                            categoryList.add(category);

                            // categoryProvider.addNewCategory(category);
                            setState(() {});
                          } else {
                            _titleCategoryController.clear();
                          }
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
                        onPressed: () async {
                          bool isNotExist = categoryList.every((element) =>
                              element.nameCat != _titleCategoryController.text);
                          if (_titleCategoryController.text.isNotEmpty &&
                              isNotExist) {
                            Category category = Category(
                                nameCat: _titleCategoryController.text);
                            DBHelper.dbhelper.createCategory(category);
                            _titleCategoryController.clear();
                            categoryList.add(category);
                            // categoryProvider.addNewCategory(category);
                            setState(() {});
                          } else {
                            _titleCategoryController.clear();
                          }
                        },
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
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: categoryList
                    .map(
                      (e) => Column(
                        children: [
                          ListTile(
                            title: Text(e.nameCat!),
                            leading: Icon(Icons.apps),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <IconButton>[
                                IconButton(
                                  onPressed: () async => await _showMyDialog(e),
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    int index = categoryList.indexOf(e);
                                    categoryList.removeAt(index);
                                    // categoryProvider.deleteCategory(e);
                                    DBHelper.dbhelper.deleteCategory(e);
                                    setState(() {});
                                  },
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
