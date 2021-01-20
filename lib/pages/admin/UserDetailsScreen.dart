import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/MyDialog.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/user.dart';

class UserDetailsScreen extends StatefulWidget {
  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

enum SearchBy { email, phone, uid }

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  SearchBy searchBy = SearchBy.email;

  bool _isLoading = false;
  bool _searchSuccess = false;

  QueryDocumentSnapshot snapshot;

  void search(String searchValue) {
    if (searchValue.isNotEmpty && searchValue.length > 4) {
      String key;

      if (searchBy == SearchBy.email) {
        key = "email";
      } else if (searchBy == SearchBy.phone) {
        key = "phone";
      } else if (searchBy == SearchBy.uid) {
        key = "uid";
      }

      setState(() {
        _isLoading = true;
      });
      searchUser(searchValue, key).then((qSnap) {
        if (qSnap.size == 0) {
          showMyDialog(
            context: context,
            title: "oops",
            description: "No user found!",
          );
          setState(() {
            _searchSuccess = false;
            _isLoading = false;
          });
        } else {
          setState(() {
            _searchSuccess = true;
            _isLoading = false;
            snapshot = qSnap.docs[0];
          });
        }
      }).catchError((e) {
        print(e);
        showMyDialog(
          context: context,
          title: "oops",
          description: "Something went wrong",
        );
        setState(() {
          _isLoading = false;
        });
      });
    } else {
      showMyDialog(
        context: context,
        title: "oops",
        description: "Please write search value",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search User"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text("Search By"),
              ),
              Row(
                children: [
                  Radio(
                    value: SearchBy.email,
                    groupValue: searchBy,
                    onChanged: (value) {
                      setState(() {
                        searchBy = value;
                      });
                    },
                  ),
                  Text("Email"),
                  Radio(
                    value: SearchBy.phone,
                    groupValue: searchBy,
                    onChanged: (value) {
                      setState(() {
                        searchBy = value;
                      });
                    },
                  ),
                  Text("Phone"),
                  Radio(
                    value: SearchBy.uid,
                    groupValue: searchBy,
                    onChanged: (value) {
                      setState(() {
                        searchBy = value;
                      });
                    },
                  ),
                  Text("User id"),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: TextField(
                  decoration: InputDecoration.collapsed(
                    hintText: "Search",
                  ),
                  textInputAction: TextInputAction.search,
                  onSubmitted: (searchValue) {
                    search(searchValue);
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (_isLoading == true) ...[
                SpinKitChasingDots(
                  color: primaryColor,
                  size: 50,
                ),
              ],
              if (_searchSuccess == true) ...[
                Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: CircleAvatar(
                          backgroundColor: primaryColor,
                          backgroundImage: NetworkImage(
                            snapshot.data()["photoURL"],
                          ),
                          radius: 50,
                        ),
                      ),
                      DataTable(
                        columns: [
                          DataColumn(label: Text("Column")),
                          DataColumn(label: Text("Data")),
                        ],
                        rows: [
                          DataRow(
                            cells: [
                              DataCell(Text("User id")),
                              DataCell(SelectableText(snapshot.data()["uid"])),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("Name")),
                              DataCell(SelectableText(
                                  snapshot.data()["displayName"])),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("Email")),
                              DataCell(
                                  SelectableText(snapshot.data()["email"])),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("Phone")),
                              DataCell(SelectableText(
                                  snapshot.data()["phone"] ?? "")),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("Alt. Phone")),
                              DataCell(SelectableText(
                                  snapshot.data()["altPhone"] ?? "")),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("Address (Home)")),
                              DataCell(SelectableText(
                                  snapshot.data()["homeAddress"] ?? "")),
                            ],
                          ),
                          DataRow(
                            cells: [
                              DataCell(Text("Address (Office)")),
                              DataCell(SelectableText(
                                  snapshot.data()["officeAddress"] ?? "")),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
