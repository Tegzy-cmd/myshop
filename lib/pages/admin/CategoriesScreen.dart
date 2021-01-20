import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/Empty.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/category.dart';
import 'package:myshop/pages/admin/CreateCategoryScreen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  bool _isLoading = false;
  bool _isEmpty = true;

  List<QueryDocumentSnapshot> categories;

  @override
  void initState() {
    _loadCategories();
    super.initState();
  }

  _loadCategories() async {
    setState(() {
      _isLoading = true;
    });

    QuerySnapshot qSnap = await getCategories();

    if (qSnap.size > 0) {
      setState(() {
        _isEmpty = false;
        _isLoading = false;
        categories = qSnap.docs;
      });
    } else {
      setState(() {
        _isEmpty = true;
        _isLoading = false;
      });
    }
  }

  onDeleteCategoryBtnTap(String catId) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text("Are you sure?"),
          content: Text(
              "Once you press delete, we will delete it from our storage, this process is irreversible."),
          actions: [
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(ctx);
              },
            ),
            FlatButton(
              textColor: Colors.red,
              child: Text("Delete Permanently"),
              onPressed: () {
                deleteCategory(catId).then((value) {
                  _loadCategories();
                  Navigator.pop(ctx);
                }).catchError((e) => print(e));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories Screen"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          String result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateCategoryScreen(),
              fullscreenDialog: true,
            ),
          );

          if (result == "added") {
            _loadCategories();
          }
        },
        label: Text("Add Category"),
        icon: Icon(Icons.add),
      ),
      body: _isLoading == true
          ? Center(
              child: SpinKitChasingDots(
              color: primaryColor,
              size: 50,
            ))
          : Container(
              child: _isEmpty == true
                  ? Empty(
                      text: "No Categories found, Add some 🙆🏻‍♀️ ",
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        return _loadCategories();
                      },
                      child: ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (ctx, i) {
                          return Container(
                            padding: EdgeInsets.all(12),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.spaceBetween,
                              children: [
                                Text(
                                  categories[i].data()["title"],
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                IconButton(
                                  tooltip: "Delete",
                                  color: Colors.red,
                                  icon: Icon(Icons.delete_forever),
                                  onPressed: () {
                                    onDeleteCategoryBtnTap(categories[i].id);
                                  },
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
    );
  }
}
