import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/config/theme.dart';
import 'package:myshop/pages/AboutShopDetails.dart';
import 'package:myshop/pages/CartScreen.dart';
import 'package:myshop/pages/EditMyAdreesScreen.dart';
import 'package:myshop/pages/EditMyPhoneScreen.dart';
import 'package:myshop/pages/HomeScreen.dart';
import 'package:myshop/pages/ShopByCategoryScreen.dart';
import 'package:myshop/pages/SplashScreen.dart';
import 'package:myshop/pages/admin/AdminHomeScreen.dart';
import 'package:myshop/pages/admin/CategoriesScreen.dart';
import 'package:myshop/pages/admin/CreateProductScreen.dart';
import 'package:myshop/pages/admin/OrdersScreenAdmin.dart';
import 'package:myshop/pages/admin/ProductsScreen.dart';
import 'package:myshop/pages/admin/ShopDetails.dart';
import 'package:myshop/pages/admin/UpdateProductScreen.dart';
import 'package:myshop/pages/admin/UserDetailsScreen.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  final FirebaseAnalytics firebaseAnalytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      statusBarColor: primaryColor,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return MaterialApp(
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: firebaseAnalytics),
      ],
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      initialRoute: "/",
      routes: {
        "/": (context) => SplashScreen(),
        "/admin": (context) => AdminHomeScreen(),
        "/admin_orders": (context) => OrdersScreenAdmin(),
        "/home": (context) => HomeScreen(),
        "/about": (context) => AboutShopDetails(),
        "/edit_my_phone_number": (context) => EditMyPhoneScreen(),
        "/edit_my_address": (context) => EditMyAddressScreen(),
        "/edit_shop_details": (context) => ShopDetailsScreen(),
        "/user_details": (context) => UserDetailsScreen(),
        "/manage_products": (context) => ProductsScreen(),
        "/create_product": (context) => CreateProductScreen(),
        "/update_product": (context) => UpdateProductScreen(),
        "/categories_admin": (context) => CategoriesScreen(),
        "/cart": (context) => CartScreen(),
        "/shop_by_category": (context) => ShopByCategoryScreen(),
      },
    );
  }
}
