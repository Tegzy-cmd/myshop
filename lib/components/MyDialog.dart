import 'package:flutter/material.dart';

void showMyDialog(
    {@required BuildContext context,
    @required String title,
    String description}) {
  showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(title),
        content: Text(description),
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: Text("Close"),
          ),
        ],
      );
    },
  );
}
