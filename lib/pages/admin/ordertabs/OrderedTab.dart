import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/Empty.dart';
import 'package:myshop/components/OrderItem.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/order.dart';
import 'package:myshop/pages/admin/OrderDetailsScreenAdmin.dart';

class OrderedTab extends StatefulWidget {
  @override
  _OrderedTabState createState() => _OrderedTabState();
}

class _OrderedTabState extends State<OrderedTab> {
  bool _loading = true;
  bool _empty = true;
  List<DocumentSnapshot> orders = List();
  DocumentSnapshot lastDocument;

  ScrollController _scrollController;

  String tab = 'ordered';

  @override
  void initState() {
    super.initState();
    loadOrders();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          print("loading more orders");
          loadMoreOrders();
        }
      });
  }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  loadOrders() async {
    try {
      QuerySnapshot qSnap = await getOrders(tab);
      if (qSnap.size > 0) {
        setState(() {
          _empty = false;
          orders = qSnap.docs;
          lastDocument = qSnap.docs.last;
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

  loadMoreOrders() async {
    try {
      QuerySnapshot qSnap = await getMoreOrders(tab, lastDocument);
      if (qSnap.size > 0) {
        setState(() {
          _empty = false;
          orders.addAll(qSnap.docs);
          lastDocument = qSnap.docs.last;
          _loading = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _loading == true
          ? Container(
              child: Center(
                child: SpinKitPulse(
                  color: primaryColor,
                  size: 50,
                ),
              ),
            )
          : _empty == true
              ? Container(
                  child: Empty(
                    text: "No orders!",
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    return await loadOrders();
                  },
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: orders.length,
                    itemBuilder: (ctx, i) {
                      return OrderItem(
                        orderSnapshot: orders[i],
                        onTap: () async {
                          String result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailsScreenAdmin(
                                orderSnap: orders[i],
                              ),
                            ),
                          );
                          if (result == "done") {
                            await loadOrders();
                          }
                        },
                      );
                    },
                  ),
                ),
    );
  }
}
