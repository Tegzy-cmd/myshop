import 'package:flutter/material.dart';
import 'package:myshop/helpers/shop.dart';
import 'package:status_alert/status_alert.dart';

class ShopDetailsScreen extends StatefulWidget {
  @override
  _ShopDetailsScreenState createState() => _ShopDetailsScreenState();
}

class _ShopDetailsScreenState extends State<ShopDetailsScreen> {
  final TextEditingController shopName = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController taxNumber = TextEditingController();
  final TextEditingController tax = TextEditingController();

  @override
  void initState() {
    super.initState();
    getShopDetails().then((doc) {
      Map<String, dynamic> shop = doc.data();
      setState(() {
        shopName.text = shop["shopName"];
        address.text = shop["address"];
        phone.text = shop["phone"];
        email.text = shop["email"];
        taxNumber.text = shop["taxNumber"];
        tax.text = shop["tax"].toString();
      });
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shop Details"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: shopName,
                decoration:
                    InputDecoration(filled: true, labelText: "Shop Name"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: address,
                decoration:
                    InputDecoration(filled: true, labelText: "Shop Address"),
                keyboardType: TextInputType.streetAddress,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: phone,
                decoration: InputDecoration(filled: true, labelText: "Phone"),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: email,
                decoration:
                    InputDecoration(filled: true, labelText: "Shop EMail"),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: taxNumber,
                decoration:
                    InputDecoration(filled: true, labelText: "Tax Number"),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: tax,
                decoration: InputDecoration(
                    filled: true, labelText: "Tax Percentage %"),
                keyboardType: TextInputType.number,
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                child: Text("Save"),
                onPressed: () {
                  double taxV = double.parse(tax.text);

                  editShopDetails(
                    address: address.text,
                    email: email.text,
                    phone: phone.text,
                    shopName: shopName.text,
                    tax: taxV,
                    taxNumber: taxNumber.text,
                  ).then((value) {
                    StatusAlert.show(
                      context,
                      title: "Saved",
                      configuration: IconConfiguration(icon: Icons.done),
                    );
                  }).catchError((e) {
                    print(e);
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
