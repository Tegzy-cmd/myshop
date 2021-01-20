import 'package:flutter/material.dart';

class Empty extends StatelessWidget {
  final String text;
  final double height;

  Empty({@required this.text, this.height = 300});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: AssetImage("assets/women_jacket.png"),
              height: height,
            ),
            SizedBox(
              height: 20,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
