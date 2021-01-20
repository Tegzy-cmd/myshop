import 'package:flutter/material.dart';
import 'package:myshop/config/colors.dart';

class OrderPlacedScreen extends StatelessWidget {
  final String orderId;
  final String orderMethod;
  OrderPlacedScreen({this.orderId, @required this.orderMethod});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Placed"),
      ),
      body: Container(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage(orderMethod == "selfPickup"
                    ? "assets/woman_cycling.gif"
                    : "assets/woman_calm.gif"),
                height: 300,
                fit: BoxFit.contain,
              ),
              SizedBox(
                height: 20,
              ),
              Text("Your Order Placed."),
              Text("Order ID: $orderId"),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                textColor: primaryColor,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Let's go, Check order screen for updates."),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
