import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:myshop/config/currency.dart';

class OrderItem extends StatelessWidget {
  final DocumentSnapshot orderSnapshot;
  final Function onTap;

  OrderItem({@required this.orderSnapshot, @required this.onTap});

  @override
  Widget build(BuildContext context) {
    var order = orderSnapshot.data();
    var id = orderSnapshot.id;

    DateTime createdAt = order['created_at'].toDate();
    String formattedDate =
        "${createdAt.year}/${createdAt.month}/${createdAt.day} ${createdAt.hour}:${createdAt.minute}:${createdAt.second}";

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey[100],
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 16,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order # $id",
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${order['cart'].length} items",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "$currencySymbol${order['total']}",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              formattedDate,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Divider(),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (order['orderStatus'] == "ordered") ...[
                  Row(
                    children: [
                      Icon(
                        EvaIcons.shoppingCartOutline,
                        color: Colors.orange,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        order['orderStatus'],
                        style: TextStyle(
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ] else if (order['orderStatus'] == "delivering") ...[
                  Row(
                    children: [
                      Icon(
                        EvaIcons.carOutline,
                        color: Colors.blue,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        order['orderStatus'],
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ] else if (order['orderStatus'] == "delivered") ...[
                  Row(
                    children: [
                      Icon(
                        EvaIcons.giftOutline,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        order['orderStatus'],
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ] else if (order['orderStatus'] == "cancelled") ...[
                  Row(
                    children: [
                      Icon(
                        EvaIcons.closeOutline,
                        color: Colors.red,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        order['orderStatus'],
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
                OutlineButton(
                  padding: EdgeInsets.symmetric(
                    vertical: 5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  textColor: Colors.grey,
                  highlightedBorderColor: Colors.black,
                  onPressed: onTap,
                  child: Text("Details"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
