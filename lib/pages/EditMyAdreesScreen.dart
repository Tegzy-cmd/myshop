import 'package:flutter/material.dart';
import 'package:myshop/helpers/user.dart';
import 'package:status_alert/status_alert.dart';

class EditMyAddressScreen extends StatefulWidget {
  @override
  _EditMyAddressScreenState createState() => _EditMyAddressScreenState();
}

class _EditMyAddressScreenState extends State<EditMyAddressScreen> {
  final TextEditingController _homeAddressController =
      TextEditingController(text: '');

  final TextEditingController _officeAddressController =
      TextEditingController(text: '');

  String homeAddress = '';
  String officeAddress = '';

  @override
  void initState() {
    getUserData().then((doc) {
      setState(() {
        homeAddress = doc.data()["homeAddress"] ?? '';
        officeAddress = doc.data()["officeAddress"] ?? '';

        _homeAddressController.text = homeAddress;
        _officeAddressController.text = officeAddress;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _homeAddressController.dispose();
    _officeAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit My Address"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _homeAddressController,
                maxLength: 120,
                decoration: InputDecoration(
                  labelText: "Home Address",
                  filled: true,
                ),
                keyboardType: TextInputType.streetAddress,
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _officeAddressController,
                maxLength: 120,
                decoration: InputDecoration(
                  labelText: "Office Address",
                  filled: true,
                ),
                keyboardType: TextInputType.streetAddress,
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                child: Text("SAVE"),
                onPressed: () {
                  String homeAddressTxt = _homeAddressController.text;
                  String officeAddressTxt = _officeAddressController.text;

                  if (homeAddressTxt != homeAddress ||
                      officeAddressTxt != officeAddress) {
                    editAddress(homeAddressTxt, officeAddressTxt).then((v) {
                      StatusAlert.show(
                        context,
                        title: "Saved",
                        configuration: IconConfiguration(icon: Icons.done),
                      );
                      Navigator.pop(context);
                    }).catchError((e) {
                      print(e);
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
