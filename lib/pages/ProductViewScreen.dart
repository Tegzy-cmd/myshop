import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/config/currency.dart';
import 'package:myshop/helpers/cart.dart';
import 'package:shimmer/shimmer.dart';
import 'package:status_alert/status_alert.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProductViewScreen extends StatelessWidget {
  final DocumentSnapshot document;
  ProductViewScreen({@required this.document});

  _addProductToCartBtnTap(context) async {
    await addProductToCart(document.id, document.data());
    StatusAlert.show(
      context,
      title: "Added to Cart",
      subtitle: "Go to cart for checkout",
      configuration: IconConfiguration(icon: Icons.done),
      duration: Duration(seconds: 4),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(document.data()["productName"]),
      ),
      body: Container(
        width: width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Stack(
                children: [
                  Container(
                    child: FadeInImage(
                      image: NetworkImage(document.data()["productImage"]),
                      placeholder: AssetImage("assets/placeholder.png"),
                      height: 300,
                      width: width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (document.data()["isFeatured"] == true) ...[
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 0,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Shimmer.fromColors(
                          baseColor: Colors.white,
                          highlightColor: primaryColor,
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.white,
                              ),
                              Text("Featured"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              // product
              SizedBox(
                height: 20,
              ),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      document.data()["productName"],
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "$currencySymbol${document.data()['salePrice'].toString()}",
                          softWrap: true,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.green[600],
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        if (document.data()["price"] !=
                            document.data()["salePrice"]) ...[
                          Text(
                            document.data()["price"].toString(),
                            softWrap: true,
                            style: TextStyle(
                              color: Colors.grey[700],
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ]
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      onPressed: () {
                        _addProductToCartBtnTap(context);
                      },
                      child: Text("Add to cart"),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "About Product",
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      document.data()["description"],
                      softWrap: true,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DataTable(columns: [
                      DataColumn(label: Text("Details")),
                      DataColumn(label: Text("")),
                    ], rows: [
                      DataRow(
                        cells: [
                          DataCell(Text("Added")),
                          DataCell(Text(timeago
                              .format(document.data()["created_at"].toDate()))),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text("Last Updated on")),
                          DataCell(Text(timeago
                              .format(document.data()["updated_at"].toDate()))),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text("Category")),
                          DataCell(Text(document.data()["category"])),
                        ],
                      ),
                    ])
                  ],
                ),
              ),

              SizedBox(
                height: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
