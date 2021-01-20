import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/config/currency.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatelessWidget {
  final QueryDocumentSnapshot product;
  final Function onTap;

  ProductCard({@required this.product, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: FadeInImage(
                    image: NetworkImage(product.data()["productImage"]),
                    placeholder: AssetImage("assets/placeholder.png"),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: 14,
                ),
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.data()["productName"],
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            "$currencySymbol${product.data()['salePrice'].toString()}",
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.green[600],
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          if (product.data()["price"] !=
                              product.data()["salePrice"]) ...[
                            Text(
                              product.data()["price"].toString(),
                              softWrap: true,
                              style: TextStyle(
                                color: Colors.grey[700],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ]
                        ],
                      ),
                      Text(
                        product.data()["category"],
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (product.data()["isFeatured"] == true) ...[
            Positioned(
              top: 5,
              left: 5,
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
    );
  }
}
