import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/config/links.dart';
import 'package:myshop/config/strings.dart';
import 'package:myshop/pages/AccountTab.dart';
import 'package:myshop/pages/HomeTab.dart';
import 'package:myshop/pages/OrdersTab.dart';
import 'package:myshop/pages/SearchTab.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

  // tabs
  final _tabs = [HomeTab(), SearchTab(), OrdersTab(), AccountTab()];
  // tabs

  @override
  void initState() {
    super.initState();
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appName),
        actions: [
          IconButton(
            tooltip: "Cart",
            icon: Icon(EvaIcons.shoppingCartOutline),
            onPressed: () {
              Navigator.pushNamed(context, "/cart");
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(FirebaseAuth.instance.currentUser.displayName),
              accountEmail: Text(FirebaseAuth.instance.currentUser.email),
              currentAccountPicture: CircleAvatar(
                backgroundImage:
                    NetworkImage(FirebaseAuth.instance.currentUser.photoURL),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: primaryColor,
              ),
            ),
            ListTile(
              onTap: () {},
              title: Text("Home"),
              leading: Icon(EvaIcons.gridOutline),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, "/shop_by_category");
              },
              title: Text("Shop By Category"),
              leading: Icon(Icons.category_outlined),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, "/cart");
              },
              title: Text("Cart"),
              leading: Icon(EvaIcons.shoppingCartOutline),
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(context, "/about");
              },
              title: Text("About $appName"),
              leading: Icon(EvaIcons.infoOutline),
            ),
            ListTile(
              onTap: () {
                _launchURL(privacyPolicyURL);
              },
              title: Text("Privacy Policy"),
              leading: Icon(EvaIcons.fileTextOutline),
            ),
            ListTile(
              onTap: () {
                _launchURL(termsAndConditionsURL);
              },
              title: Text("Terms and Conditions"),
              leading: Icon(EvaIcons.fileTextOutline),
            ),
          ],
        ),
      ),
      body: SizedBox.expand(
        child: _tabs[_currentTab],
      ),
      bottomNavigationBar: BottomNavyBar(
        curve: Curves.ease,
        selectedIndex: _currentTab,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        onItemSelected: (i) {
          setState(() {
            _currentTab = i;
          });
        },
        items: [
          BottomNavyBarItem(
            activeColor: primaryColor,
            inactiveColor: Colors.grey,
            textAlign: TextAlign.center,
            title: Text("Home"),
            icon: Icon(EvaIcons.gridOutline),
          ),
          BottomNavyBarItem(
            activeColor: primaryColor,
            inactiveColor: Colors.grey,
            textAlign: TextAlign.center,
            title: Text("Search"),
            icon: Icon(EvaIcons.searchOutline),
          ),
          BottomNavyBarItem(
            activeColor: primaryColor,
            inactiveColor: Colors.grey,
            textAlign: TextAlign.center,
            title: Text("Orders"),
            icon: Icon(EvaIcons.shoppingBagOutline),
          ),
          BottomNavyBarItem(
            activeColor: primaryColor,
            inactiveColor: Colors.grey,
            textAlign: TextAlign.center,
            title: Text("Profile"),
            icon: Icon(EvaIcons.personOutline),
          ),
        ],
      ),
    );
  }
}
