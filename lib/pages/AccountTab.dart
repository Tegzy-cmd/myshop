import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myshop/helpers/auth.dart';

class AccountTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(FirebaseAuth.instance.currentUser.displayName),
            accountEmail: Text(FirebaseAuth.instance.currentUser.email),
            currentAccountPicture: CircleAvatar(
              backgroundImage:
                  NetworkImage(FirebaseAuth.instance.currentUser.photoURL),
            ),
          ),
          Divider(),
          ListTile(
            title: Text("Edit My Address"),
            onTap: () {
              Navigator.pushNamed(context, "/edit_my_address");
            },
          ),
          Divider(),
          ListTile(
            title: Text("Edit My Phone"),
            onTap: () {
              Navigator.pushNamed(context, "/edit_my_phone_number");
            },
          ),
          Divider(),
          ListTile(
            title: Text("Logout"),
            onTap: () {
              signOut().then((v) {
                Navigator.pushReplacementNamed(context, "/");
              });
            },
          ),
        ],
      ),
    );
  }
}
