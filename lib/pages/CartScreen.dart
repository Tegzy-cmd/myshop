import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myshop/components/CartItem.dart';
import 'package:myshop/components/Empty.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/helpers/cart.dart';
import 'package:myshop/pages/CheckoutScreen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isEmpty = false;
  bool _isLoading = true;
  List cart = List();

  @override
  void initState() {
    super.initState();
    loadProductsFromCart();
  }

  loadProductsFromCart() async {
    setState(() {
      _isLoading = true;
    });

    dynamic c = await getCart();
    if (c != null && c.length > 0) {
      setState(() {
        cart = c;
        _isEmpty = false;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isEmpty = true;
        _isLoading = false;
      });
    }
  }

  btnOnDeleteCartItemTap(index) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text("Are you sure?"),
          content: Text("You are going to remove the product from your cart."),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text("Cancel"),
            ),
            FlatButton(
              textColor: Colors.red,
              onPressed: () async {
                await deleteProductFromCart(index);

                await loadProductsFromCart();
                Navigator.pop(ctx);
              },
              child: Text("Yes, Delete it"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
      ),
      body: _isLoading == true
          ? Container(
              child: Center(
                child: SpinKitChasingDots(
                  color: primaryColor,
                  size: 50,
                ),
              ),
            )
          : _isEmpty == true
              ? Empty(text: "No products in your cart!")
              : Container(
                  child: Column(
                    children: [
                      Flexible(
                        child: RefreshIndicator(
                          onRefresh: () async {
                            return loadProductsFromCart();
                          },
                          child: ListView.separated(
                            itemBuilder: (ctx, i) {
                              return CartItem(
                                product: cart[i],
                                onDeleteTap: () {
                                  btnOnDeleteCartItemTap(i);
                                },
                              );
                            },
                            separatorBuilder: (ctx, i) => Divider(),
                            itemCount: cart.length,
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 30,
                              color: Color(0x44000000),
                            ),
                          ],
                        ),
                        child: RaisedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutScreen(
                                  cart: cart,
                                ),
                              ),
                            );
                          },
                          child: Text("Proceed to checkout"),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
