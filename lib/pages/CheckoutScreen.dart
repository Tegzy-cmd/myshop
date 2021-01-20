import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/MyDialog.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/config/currency.dart';
import 'package:myshop/config/payment_options.dart';
import 'package:myshop/helpers/cart.dart';
import 'package:myshop/helpers/order.dart';
import 'package:myshop/helpers/shop.dart';
import 'package:myshop/pages/OrderPlacedScreen.dart';
import 'package:myshop/pages/PayOnDeliveryOrderScreen.dart';

class CheckoutScreen extends StatefulWidget {
  final List cart;

  CheckoutScreen({@required this.cart});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _loading = true;
  double cartItemsTotal = 0;
  double total = 0;
  double taxAmount = 0;
  int tax = 0;
  DocumentSnapshot shopDetails;

  @override
  void initState() {
    super.initState();
    preparePayment();
  }

  preparePayment() async {
    // calculate total
    double cartTotal = 0;
    List cart = widget.cart;

    cart.forEach((c) {
      double salePrice = c["salePrice"];
      cartTotal += salePrice;
    });

    cartTotal = double.parse(cartTotal.toStringAsFixed(2));

    var shopDetailsFromDB = await getShopDetails();
    int taxInt = 0;
    double payableAmount = cartTotal;
    double payableTaxAmount = 0;

    if (shopDetailsFromDB.exists) {
      if (shopDetailsFromDB.data()["tax"] != null) {
        double taxDouble =
            double.parse(shopDetailsFromDB.data()["tax"].toString());
        taxInt = taxDouble.toInt();

        // calculate percentage of tax
        payableTaxAmount = (cartTotal * taxInt) / 100;
        payableTaxAmount = double.parse(payableTaxAmount.toStringAsFixed(2));

        payableAmount += payableTaxAmount;
      }
    }

    payableAmount = double.parse(payableAmount.toStringAsFixed(2));

    setState(() {
      cartItemsTotal = cartTotal;
      shopDetails = shopDetailsFromDB;
      tax = taxInt;
      taxAmount = payableTaxAmount;
      total = payableAmount;
      _loading = false;
    });
  }

  onBtnPayOnDeliveryTap() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PayOnDeliveryOrderScreen(
          cart: widget.cart,
          cartItemsTotal: cartItemsTotal,
          tax: tax,
          taxAmount: taxAmount,
          total: total,
        ),
      ),
    );
  }

  onBtnSelfPickupTap() async {
    try {
      DocumentReference ref = await addOrderSelfPickup(
        widget.cart,
        cartItemsTotal,
        tax,
        taxAmount,
        total,
      );
      await clearCart();
      String orderId = ref.id;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => OrderPlacedScreen(
            orderId: orderId,
            orderMethod: "selfPickup",
          ),
        ),
        ModalRoute.withName("/home"),
      );
    } catch (e) {
      print(e);
      showMyDialog(
        context: context,
        title: "oops",
        description: "Something went wrong, try after some time!",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
      ),
      body: _loading == true
          ? Container(
              child: Center(
                child: SpinKitChasingDots(
                  color: primaryColor,
                  size: 50,
                ),
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 80,
                      ),
                      // total amout

                      Text("Total Payable Amount"),
                      Text(
                        "$currencySymbol$total",
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),

                      SizedBox(
                        height: 40,
                      ),

                      // payment options
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Payment options:"),
                            // SizedBox(
                            //   height: 10,
                            // ),
                            // FlatButton(
                            //   color: Colors.grey[300],
                            //   textColor: Colors.black,
                            //   onPressed: () {},
                            //   child: Text("Pay Online"),
                            // ),

                            if (payOnDelivery) ...[
                              SizedBox(
                                height: 10,
                              ),
                              FlatButton(
                                color: Colors.grey[300],
                                textColor: Colors.black,
                                onPressed: () {
                                  onBtnPayOnDeliveryTap();
                                },
                                child: Text("Pay on Delivery"),
                              ),
                            ],

                            if (selfPickup == true) ...[
                              SizedBox(
                                height: 10,
                              ),
                              FlatButton(
                                color: Colors.grey[300],
                                textColor: Colors.black,
                                onPressed: () {
                                  onBtnSelfPickupTap();
                                },
                                child: Text("Self Pickup"),
                              ),
                            ],
                          ],
                        ),
                      ),

                      SizedBox(
                        height: 40,
                      ),

                      // datatable -> total price, tax, fee
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("Payment Details:"),
                            SizedBox(
                              height: 10,
                            ),
                            DataTable(
                              columns: [
                                DataColumn(
                                  label: Text("Name"),
                                ),
                                DataColumn(
                                  label: Text("Amount"),
                                ),
                              ],
                              rows: [
                                DataRow(
                                  cells: [
                                    DataCell(Text("Cart Total")),
                                    DataCell(
                                        Text("$currencySymbol$cartItemsTotal")),
                                  ],
                                ),
                                DataRow(
                                  cells: [
                                    DataCell(Text("Tax")),
                                    DataCell(Text(
                                        "$currencySymbol$taxAmount ($tax%)")),
                                  ],
                                ),
                                DataRow(
                                  cells: [
                                    DataCell(Text("Total")),
                                    DataCell(Text("$currencySymbol$total")),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
