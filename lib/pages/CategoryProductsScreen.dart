import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/Empty.dart';
import 'package:myshop/components/ProductCard.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/product.dart';
import 'package:myshop/pages/ProductViewScreen.dart';

class CategoryProductsScreen extends StatefulWidget {
  final DocumentSnapshot category;
  CategoryProductsScreen({@required this.category});
  @override
  _CategoryProductsScreenState createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  bool _isLoading = false;
  bool _isEmpty = false;
  List<QueryDocumentSnapshot> products = List();
  QueryDocumentSnapshot lastDocument;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadProducts();
    _scrollController
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          print("loading more uploads");
          loadMoreProducts();
        }
      });
  }

  loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    QuerySnapshot qsnap = await getProductsByCategory(widget.category.id);
    if (qsnap.size > 0) {
      if (this.mounted) {
        setState(() {
          _isLoading = false;
          _isEmpty = false;
          products = qsnap.docs;
          lastDocument = qsnap.docs.last;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
        _isEmpty = true;
      });
    }
  }

  loadMoreProducts() async {
    QuerySnapshot qsnap =
        await getMoreProductsByCategory(widget.category.id, lastDocument);
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
        title: Text(widget.category.id),
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
                ? Empty(text: "No products found!")
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
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductViewScreen(
                                  document: products[i],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
