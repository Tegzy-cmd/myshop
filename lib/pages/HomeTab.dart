import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/Empty.dart';
import 'package:myshop/components/ProductCard.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/product.dart';
import 'package:myshop/pages/ProductViewScreen.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
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

    QuerySnapshot qsnap = await getProducts();
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
    if (_isLoading == true) {
      return Container(
        child: Center(
          child: SpinKitChasingDots(
            color: primaryColor,
            size: 50,
          ),
        ),
      );
    } else {
      if (_isEmpty == true) {
        return Container(
          child: Empty(text: "No products found!"),
        );
      } else {
        return Container(
          child: RefreshIndicator(
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
        );
      }
    }
  }
}
