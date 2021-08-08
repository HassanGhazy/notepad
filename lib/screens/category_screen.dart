import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../helper/mycolor.dart';
import '../helper/db_helper.dart';
import '../models/Category.dart';
import '../widgets/my_drawer.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _titleCategoryController =
      TextEditingController();
  final TextEditingController _changetitleCategoryController =
      TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  List<Category> categoryList = <Category>[];
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
    DBHelper.dbhelper
        .getAllCategories()
        .then((List<Category> value) => categoryList = value);
  }

  Future<void> _showMyDialog(Category cat) async {
    _changetitleCategoryController.text = cat.nameCat!;
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Categorie').tr(),
          content: TextFormField(
            controller: _changetitleCategoryController,
            maxLines: 1,
            decoration: InputDecoration(
              hintText: 'edit category name'.tr(),
              hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            onFieldSubmitted: (_) {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve').tr(),
              onPressed: () async {
                if (_changetitleCategoryController.text != "") {
                  final int index = categoryList.indexOf(cat);
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

  Future<void> deleteCategoryAlert(Category e) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // !user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
              "${"Delete category".tr()} '${e.nameCat}'? ${"Notes from the category won't be deleted".tr()}"),
          actions: <TextButton>[
            TextButton(
              child: Text(
                'CANCEL',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: MyColor.textColor),
              ).tr(),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'OK',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: MyColor.textColor),
              ).tr(),
              onPressed: () {
                final int index = categoryList.indexOf(e);
                categoryList.removeAt(index);
                DBHelper.dbhelper.deleteCategory(e);
                setState(() {});

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
        if (mounted) {
          _finishGetData = true;
          setState(() {});
        }
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories").tr(),
        backgroundColor: const Color(0xff907854),
      ),
      backgroundColor: const Color(0xffFDFCCE),
      drawer: MyDrawer(),
      body: Column(
        children: <Widget>[
          Container(
            height: 70,
            child: Form(
              key: _form,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: _titleCategoryController,
                        maxLines: 1,
                        decoration: InputDecoration(
                          hintText: 'New category name'.tr(),
                          hintStyle:
                              TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final bool isNotExist = categoryList.every(
                              (Category element) =>
                                  element.nameCat !=
                                  _titleCategoryController.text);
                          if (_titleCategoryController.text.isNotEmpty &&
                              isNotExist) {
                            final Category category = Category(
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
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(25),
                        ),
                        border: Border.all(color: const Color(0xff999999)),
                        gradient: const LinearGradient(
                          colors: <Color>[Color(0xffFAFAC6), Color(0xffFAF4B6)],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () async {
                          final bool isNotExist = categoryList.every(
                              (Category element) =>
                                  element.nameCat !=
                                  _titleCategoryController.text);
                          if (_titleCategoryController.text.isNotEmpty &&
                              isNotExist) {
                            final Category category = Category(
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
                        child: const Text(
                          'Add',
                          style: TextStyle(color: Colors.black),
                        ).tr(),
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
                      (Category e) => Column(
                        children: <Widget>[
                          ListTile(
                            title: Text(e.nameCat!),
                            leading: const Icon(Icons.apps),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <IconButton>[
                                IconButton(
                                  onPressed: () async => await _showMyDialog(e),
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    deleteCategoryAlert(e);
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.black,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Divider(),
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
