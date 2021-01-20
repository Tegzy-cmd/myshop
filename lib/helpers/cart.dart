import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

Future<void> addProductToCart(String id, Map<String, dynamic> data) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic productsList = List();

    dynamic productToSave = {
      "id": id,
      "productName": data["productName"],
      "productImage": data["productImage"],
      "price": data["price"],
      "salePrice": data["salePrice"],
    };

    // get exsisting products
    String products = prefs.getString("cart") ?? '';

    // add new product
    if (products != '' && products != null) {
      productsList = json.decode(products);
    }

    productsList.add(productToSave);

    // save
    String cart = json.encode(productsList);

    await prefs.setString("cart", cart);
  } catch (e) {
    print(e);
  }
}

Future<dynamic> getCart() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    dynamic productsList = List();

    // get exsisting products
    String products = prefs.getString("cart") ?? '';

    if (products == '') {
      return null;
    } else {
      productsList = json.decode(products);
      return productsList;
    }
  } catch (e) {
    print(e);
    return null;
  }
}

Future<void> deleteProductFromCart(index) async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List productsList = List();

    // get exsisting products
    String products = prefs.getString("cart") ?? '';

    productsList = json.decode(products);

    productsList.removeAt(index);
    // save
    String cart = json.encode(productsList);

    await prefs.setString("cart", cart);
  } catch (e) {
    print(e);
    return null;
  }
}

Future<void> clearCart() async {
  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("cart");
  } catch (e) {
    print(e);
  }
}
