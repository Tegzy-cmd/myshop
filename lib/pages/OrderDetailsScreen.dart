import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/config/currency.dart';
import 'package:myshop/helpers/user.dart';

class OrderDetailsScreen extends StatefulWidget {
  final DocumentSnapshot order;

  OrderDetailsScreen({@required this.order});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    DocumentSnapshot orderSnap = widget.order;
    String id = orderSnap.id;

    Map<String, dynamic> order = orderSnap.data();

    DateTime createdAt = order['created_at'].toDate();
    String formattedDate =
        "${createdAt.year}/${createdAt.month}/${createdAt.day} ${createdAt.hour}:${createdAt.minute}:${createdAt.second}";

    List<dynamic> cart = order['cart'];

    return Scaffold(
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Order # $id",
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
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
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "${order['cart'].length} items",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Column(
                    children: cart.map((c) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 5,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: FadeInImage(
                                image: NetworkImage(c["productImage"]),
                                placeholder:
                                    AssetImage("assets/placeholder.png"),
                                width: 60,
                                height: 60,
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
                                    c["productName"],
                                    softWrap: true,
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "$currencySymbol${c['salePrice'].toString()}",
                                        softWrap: true,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.green[600],
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      if (c["price"] != c["salePrice"]) ...[
                                        Text(
                                          c["price"].toString(),
                                          softWrap: true,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ]
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Cart Total",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "$currencySymbol${order['cartItemsTotal']}",
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tax",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "$currencySymbol${order['taxAmount']} (${order['tax']}%)",
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Grant Total",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "$currencySymbol${order['total']}",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                Text("Customer Details"),
                SizedBox(
                  height: 10,
                ),
                FutureBuilder(
                  future: getUserData(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      DocumentSnapshot userSnap = snapshot.data;
                      Map<String, dynamic> user = userSnap.data();
                      return Container(
                        child: DataTable(
                          columns: [
                            DataColumn(label: Text("Name")),
                            DataColumn(label: Text(user["displayName"] ?? '')),
                          ],
                          rows: [
                            DataRow(
                              cells: [
                                DataCell(Text("Payment Method")),
                                DataCell(Text(order["paymentMethod"]
                                    .toString()
                                    .toUpperCase())),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(Text("Payment Status")),
                                DataCell(Text(order["paymentStatus"]
                                    .toString()
                                    .toUpperCase())),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(Text("Address")),
                                DataCell(Text(order['address'] ?? '')),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(Text("Address Type")),
                                DataCell(Text(order['addressType'] ?? '')),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(Text("Phone")),
                                DataCell(Text(order['phone'] ?? '')),
                              ],
                            ),
                            DataRow(
                              cells: [
                                DataCell(Text("EMail")),
                                DataCell(Text(user["email"] ?? '')),
                              ],
                            ),
                          ],
                        ),
                      );
                    }
                    return Container(
                      child: Center(
                        child: SpinKitFadingCircle(
                          color: primaryColor,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
