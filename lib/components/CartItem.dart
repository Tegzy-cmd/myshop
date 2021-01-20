import 'package:flutter/material.dart';
import 'package:myshop/config/currency.dart';

class CartItem extends StatelessWidget {
  final dynamic product;
  final Function onDeleteTap;

  CartItem({@required this.product, @required this.onDeleteTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
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
                image: NetworkImage(product["productImage"]),
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
                    product["productName"],
                    softWrap: true,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "$currencySymbol${product['salePrice'].toString()}",
                        softWrap: true,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green[600],
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      if (product["price"] != product["salePrice"]) ...[
                        Text(
                          product["price"].toString(),
                          softWrap: true,
                          style: TextStyle(
                            color: Colors.grey[700],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      onDeleteTap();
                    },
                    color: Colors.red,
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
