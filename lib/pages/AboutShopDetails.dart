import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/config/strings.dart';
import 'package:myshop/helpers/shop.dart';

class AboutShopDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About $appName"),
      ),
      body: FutureBuilder(
        future: getShopDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var shop = snapshot.data;
            return Container(
              child: SingleChildScrollView(
                child: Center(
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text("")),
                      DataColumn(label: Text("")),
                    ],
                    rows: [
                      DataRow(
                        cells: [
                          DataCell(Text("Shop Name")),
                          DataCell(Text(shop.data()["shopName"] ?? "")),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text("Address")),
                          DataCell(Text(shop.data()["address"] ?? "")),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text("Phone")),
                          DataCell(Text(shop.data()["phone"] ?? "")),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text("EMail")),
                          DataCell(Text(shop.data()["email"] ?? "")),
                        ],
                      ),
                      DataRow(
                        cells: [
                          DataCell(Text("Tax ID")),
                          DataCell(Text(shop.data()["taxNumber"] ?? "")),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return Container(
            child: Center(
              child: SpinKitChasingDots(
                color: primaryColor,
                size: 50,
              ),
            ),
          );
        },
      ),
    );
  }
}
