import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:myshop/pages/admin/ordertabs/CancelledTab.dart';
import 'package:myshop/pages/admin/ordertabs/DeliveredTab.dart';
import 'package:myshop/pages/admin/ordertabs/DeliveringTab.dart';
import 'package:myshop/pages/admin/ordertabs/OrderedTab.dart';

class OrdersScreenAdmin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Orders"),
          bottom: TabBar(
            isScrollable: true,
            indicatorWeight: 6,
            tabs: [
              Tab(
                icon: Icon(EvaIcons.shoppingCartOutline),
                text: "Ordered",
              ),
              Tab(
                icon: Icon(EvaIcons.carOutline),
                text: "Delivering",
              ),
              Tab(
                icon: Icon(EvaIcons.giftOutline),
                text: "Delivered",
              ),
              Tab(
                icon: Icon(EvaIcons.closeOutline),
                text: "Cancelled",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrderedTab(),
            DeliveringTab(),
            DeliveredTab(),
            CancelledTab(),
          ],
        ),
      ),
    );
  }
}
