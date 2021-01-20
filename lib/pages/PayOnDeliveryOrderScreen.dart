import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/MyDialog.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/cart.dart';
import 'package:myshop/helpers/order.dart';
import 'package:myshop/helpers/user.dart';
import 'package:myshop/pages/OrderPlacedScreen.dart';

class PayOnDeliveryOrderScreen extends StatefulWidget {
  final List cart;
  final double cartItemsTotal;
  final int tax;
  final double taxAmount;
  final double total;

  PayOnDeliveryOrderScreen({
    @required this.cart,
    @required this.cartItemsTotal,
    @required this.tax,
    @required this.taxAmount,
    @required this.total,
  });

  @override
  _PayOnDeliveryOrderScreenState createState() =>
      _PayOnDeliveryOrderScreenState();
}

class _PayOnDeliveryOrderScreenState extends State<PayOnDeliveryOrderScreen> {
  bool _isLoading = true;
  String addressType = 'home';

  String homeAddress = '';
  String officeAddress = '';

  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserDetails();
  }

  loadUserDetails() async {
    try {
      DocumentSnapshot user = await getUserData();
      String home = user.data()["homeAddress"] ?? '';
      String office = user.data()["officeAddress"] ?? '';

      String phone = user.data()["phone"] ?? '';

      setState(() {
        _addressController.text = home;
        _phoneController.text = phone;
        homeAddress = home;
        officeAddress = office;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  onBtnPlaceOrderTap() async {
    String address = _addressController.text;
    String phone = _phoneController.text;

    if (address.isNotEmpty && phone.isNotEmpty) {
      try {
        setState(() {
          _isLoading = true;
        });
        DocumentReference ref = await addOrderPayOnDelivery(
          widget.cart,
          widget.cartItemsTotal,
          widget.tax,
          widget.taxAmount,
          widget.total,
          addressType,
          address,
          phone,
        );
        await clearCart();
        setState(() {
          _isLoading = false;
        });
        String orderId = ref.id;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OrderPlacedScreen(
              orderId: orderId,
              orderMethod: "payOnDelivery",
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
    } else {
      showMyDialog(
        context: context,
        title: 'oops',
        description: 'Please provide your address, phone',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order Screen"),
      ),
      body: _isLoading == true
          ? Container(
              child: Center(
                child: SpinKitChasingDots(
                  color: primaryColor,
                  size: 50,
                ),
              ),
            )
          : Container(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text("Address Type"),
                      Row(
                        children: [
                          Radio(
                            value: 'home',
                            groupValue: addressType,
                            onChanged: (v) {
                              setState(() {
                                addressType = v;
                                _addressController.text = homeAddress;
                              });
                            },
                          ),
                          Text("Home"),
                          Radio(
                            value: 'office',
                            groupValue: addressType,
                            onChanged: (v) {
                              setState(() {
                                addressType = v;
                                _addressController.text = officeAddress;
                              });
                            },
                          ),
                          Text("Office"),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: "Address",
                        ),
                        keyboardType: TextInputType.streetAddress,
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text("Phone"),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: "Phone Number",
                        ),
                        maxLength: 15,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        child: Text("Place Order"),
                        onPressed: () {
                          onBtnPlaceOrderTap();
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
