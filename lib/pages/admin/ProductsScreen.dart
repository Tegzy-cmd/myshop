import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/Empty.dart';
import 'package:myshop/components/MyDialog.dart';
import 'package:myshop/components/ProductCard.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/product.dart';
import 'package:myshop/pages/admin/CreateProductScreen.dart';
import 'package:myshop/pages/admin/ProductUpdateScreen.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _isLoading = false;
  bool _isEmpty = false;
  List<QueryDocumentSnapshot> products;
  QueryDocumentSnapshot lastDocument;

  ScrollController _scrollController;

  @override
  void initState() {
    loadProducts();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          print("loading more uploads");
          loadMoreProducts();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    QuerySnapshot qsnap = await getProducts();
    if (qsnap.size > 0) {
      setState(() {
        products = qsnap.docs;
        lastDocument = qsnap.docs.last;
        _isLoading = false;
        _isEmpty = false;
      });
    } else {
      setState(() {
        _isEmpty = true;
        _isLoading = false;
      });
    }
  }

  loadMoreProducts() async {
    QuerySnapshot qsnap = await getMoreProducts(lastDocument);
    if (qsnap.size > 0) {
      setState(() {
        products.addAll(qsnap.docs);
        lastDocument = qsnap.docs.last;
        _isLoading = false;
        _isEmpty = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Products"),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          try {
            String result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => CreateProductScreen(),
                fullscreenDialog: true,
              ),
            );

            if (result == "done") {
              loadProducts();
            } else if (result == "failed") {
              showMyDialog(
                context: context,
                title: "oops",
                description: "Something went wrong",
              );
            }
          } catch (e) {
            print(e);
          }
        },
        label: Text("Create product"),
        icon: Icon(Icons.add),
      ),
      body: Container(
        child: _isLoading == true
            ? Center(
                child: SpinKitChasingDots(
                  color: primaryColor,
                  size: 50,
                ),
              )
            : _isEmpty == true
                ? Empty(text: "No products found! Add now...")
                : RefreshIndicator(
                    onRefresh: () async {
                      return loadProducts();
                    },
                    child: ListView.separated(
                      controller: _scrollController,
                      itemCount: products.length,
                      separatorBuilder: (ctx, i) {
                        return Divider();
                      },
                      itemBuilder: (ctx, i) {
                        return ProductCard(
                          product: products[i],
                          onTap: () async {
                            String result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductUpdateScreen(
                                  document: products[i],
                                ),
                              ),
                            );
                            if (result == "done") {
                              loadProducts();
                            }
                          },
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
