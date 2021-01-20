import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/ProductCard.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/product.dart';
import 'package:myshop/pages/ProductViewScreen.dart';

class SearchTab extends StatefulWidget {
  @override
  _SearchTabState createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  bool _loading = false;
  bool _empty = false;

  List<DocumentSnapshot> products = List();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
            ),
            child: TextField(
              decoration: InputDecoration.collapsed(
                hintText: "Search",
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (searchValue) async {
                if (searchValue.length > 3) {
                  setState(() {
                    _loading = true;
                  });
                  QuerySnapshot qSnap = await searchProduct(searchValue);
                  if (qSnap.size > 0) {
                    setState(() {
                      products = qSnap.docs;
                      _loading = false;
                      _empty = false;
                    });
                  } else {
                    setState(() {
                      _loading = false;
                      _empty = true;
                    });
                  }
                }
              },
            ),
          ),
          _loading == true
              ? Container(
                  child: Center(
                    child: SpinKitPulse(
                      color: primaryColor,
                      size: 50,
                    ),
                  ),
                )
              : _empty == true
                  ? Text("No Products found!")
                  : Flexible(
                      child: ListView.builder(
                        itemCount: products.length,
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
        ],
      ),
    );
  }
}
