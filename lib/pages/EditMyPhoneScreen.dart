import 'package:flutter/material.dart';
import 'package:myshop/helpers/user.dart';
import 'package:status_alert/status_alert.dart';

class EditMyPhoneScreen extends StatefulWidget {
  @override
  _EditMyPhoneScreenState createState() => _EditMyPhoneScreenState();
}

class _EditMyPhoneScreenState extends State<EditMyPhoneScreen> {
  final TextEditingController _phoneController =
      TextEditingController(text: '');

  final TextEditingController _altPhoneController =
      TextEditingController(text: '');

  String phone = '';
  String altPhone = '';

  @override
  void initState() {
    getUserData().then((doc) {
      setState(() {
        phone = doc.data()["phone"] ?? '';
        altPhone = doc.data()["altPhone"] ?? '';

        _phoneController.text = phone;
        _altPhoneController.text = altPhone;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _altPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit My Phone Number"),
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
                controller: _phoneController,
                maxLength: 15,
                decoration: InputDecoration(
                  labelText: "Phone",
                  filled: true,
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(
                height: 10,
              ),
              TextField(
                controller: _altPhoneController,
                maxLength: 15,
                decoration: InputDecoration(
                  labelText: "Alternative Phone",
                  filled: true,
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
                child: Text("SAVE"),
                onPressed: () {
                  String phoneInput = _phoneController.text;
                  String altPhoneInput = _altPhoneController.text;

                  if (phoneInput != phone || altPhoneInput != altPhone) {
                    editPhoneNumber(phoneInput, altPhoneInput).then((v) {
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
