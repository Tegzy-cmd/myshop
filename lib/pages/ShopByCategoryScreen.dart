import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/Empty.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/category.dart';
import 'package:myshop/pages/CategoryProductsScreen.dart';

class ShopByCategoryScreen extends StatefulWidget {
  @override
  _ShopByCategoryScreenState createState() => _ShopByCategoryScreenState();
}

class _ShopByCategoryScreenState extends State<ShopByCategoryScreen> {
  bool _loading = true;
  bool _empty = true;

  List<DocumentSnapshot> categories = List();

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  loadCategories() async {
    try {
      QuerySnapshot qSnap = await getCategories();
      if (qSnap.size > 0) {
        setState(() {
          categories = qSnap.docs;
          _loading = false;
          _empty = false;
        });
      } else {
        setState(() {
          _loading = false;
          _empty = true;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _loading = false;
        _empty = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop By Category"),
      ),
      body: Container(
        child: _loading == true
            ? Center(
                child: SpinKitPulse(
                  color: primaryColor,
                  size: 50,
                ),
              )
            : _empty == true
                ? Empty(text: "No categories found!")
                : GridView.count(
                    crossAxisCount: 2,
                    children: categories.map((category) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CategoryProductsScreen(category: category),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: tileColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              category.id,
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
      ),
    );
  }
}
