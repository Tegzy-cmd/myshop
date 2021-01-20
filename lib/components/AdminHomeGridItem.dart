import 'package:flutter/material.dart';

class AdminHomeGridItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;

  final Function onTap;

  AdminHomeGridItem(
      {@required this.icon,
      this.iconColor = Colors.amber,
      this.text = "",
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: iconColor),
            SizedBox(
              height: 5,
            ),
            Text(text),
          ],
        ),
      ),
    );
  }
}
