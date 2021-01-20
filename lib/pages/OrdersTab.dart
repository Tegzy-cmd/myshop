import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/Empty.dart';
import 'package:myshop/components/OrderItem.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/order.dart';
import 'package:myshop/pages/OrderDetailsScreen.dart';

class OrdersTab extends StatefulWidget {
  @override
  _OrdersTabState createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  bool _loading = true;
  bool _empty = true;
  List<QueryDocumentSnapshot> orders = List();
  @override
  void initState() {
    super.initState();
    loadMyOrders();
  }

  loadMyOrders() async {
    try {
      QuerySnapshot qSnap = await getAllOrdersOfUser();
      if (qSnap.size > 0) {
        setState(() {
          orders = qSnap.docs;
          _empty = false;
          _loading = false;
        });
      } else {
        setState(() {
          _empty = true;
          _loading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        _empty = true;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading == true) {
      return Container(
        child: SpinKitChasingDots(
          color: primaryColor,
          size: 50,
        ),
      );
    }
    if (_empty == true) {
      return Empty(text: "No orders!");
    }
    return Container(
      child: RefreshIndicator(
        onRefresh: () async {
          return loadMyOrders();
        },
        child: ListView.builder(
          itemBuilder: (ctx, i) {
            return OrderItem(
              orderSnapshot: orders[i],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderDetailsScreen(
                      order: orders[i],
                    ),
                  ),
                );
              },
            );
          },
          itemCount: orders.length,
        ),
      ),
    );
  }
}
