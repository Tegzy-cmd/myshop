import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myshop/components/MyDialog.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/config/currency.dart';
import 'package:myshop/helpers/category.dart';
import 'package:myshop/helpers/product.dart';

class ProductUpdateScreen extends StatefulWidget {
  final DocumentSnapshot document;

  ProductUpdateScreen({@required this.document});

  @override
  _ProductUpdateScreenState createState() => _ProductUpdateScreenState();
}

class _ProductUpdateScreenState extends State<ProductUpdateScreen> {
  List<QueryDocumentSnapshot> _categories;

  bool _loading = false;

  // product fields
  String category = '';
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  bool isFeatured = true;
  // product fields

  @override
  void dispose() {
    productNameController.dispose();
    priceController.dispose();
    salePriceController.dispose();
    productDescriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    loadCategories();
    productNameController.text = widget.document.data()["productName"];
    productDescriptionController.text = widget.document.data()["description"];
    priceController.text = widget.document.data()["price"].toString();
    salePriceController.text = widget.document.data()["salePrice"].toString();
    isFeatured = widget.document.data()["isFeatured"];
    super.initState();
  }

  loadCategories() async {
    try {
      setState(() {
        _loading = true;
      });

      QuerySnapshot qsnap = await getCategories();
      setState(() {
        _categories = qsnap.docs;
        category = widget.document.data()["category"];
        _loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  onUpdateProductBtnTap() async {
    try {
      String productName = productNameController.text;
      String description = productDescriptionController.text;

      if (productName.isNotEmpty &&
          priceController.text.isNotEmpty &&
          salePriceController.text.isNotEmpty) {
        double price = double.parse(priceController.text);
        double salePrice = double.parse(salePriceController.text);

        if (salePrice <= price) {
          setState(() {
            _loading = true;
          });
          print(
              "$productName \n $description \n $price $salePrice \n $category  $isFeatured");

          updateProduct(
            widget.document.id,
            productName,
            description,
            price,
            salePrice,
            category,
            isFeatured,
          ).then((v) {
            Navigator.pop(context, "done");
          }).catchError((e) {
            Navigator.pop(context, "failed");
            print(e);
          });
        } else {
          showMyDialog(
            context: context,
            title: "oops",
            description: "Sale Price should not be more than Price.",
          );
        }
      } else {
        showMyDialog(
          context: context,
          title: "oops",
          description: "Please provide all details.",
        );
      }
    } catch (e) {
      print(e);
    }
  }

  onDeleteProductBtnTap() async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Text("Are you sure?"),
          content: Text(
              "Once you press delete, we will delete it from our storage, this process is irreversible."),
          actions: [
            FlatButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(ctx);
              },
            ),
            FlatButton(
              textColor: Colors.red,
              child: Text("Delete Permanently"),
              onPressed: () {
                deleteProduct(widget.document.id,
                        widget.document.data()["productImage"])
                    .then((value) {
                  Navigator.pop(ctx);
                }).catchError((e) {
                  print(e);
                  Navigator.pop(ctx);
                });
              },
            ),
          ],
        );
      },
    );
    Navigator.pop(context, "done");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              onDeleteProductBtnTap();
            },
          ),
        ],
      ),
      body: _loading == true
          ? Center(
              child: SpinKitChasingDots(
                color: primaryColor,
                size: 50,
              ),
            )
          : Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FadeInImage(
                      placeholder: AssetImage("assets/placeholder.png"),
                      image:
                          NetworkImage(widget.document.data()["productImage"]),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        labelText: "Product Name",
                      ),
                      maxLength: 120,
                      controller: productNameController,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        labelText: "Description",
                      ),
                      maxLines: 6,
                      controller: productDescriptionController,
                      maxLength: 600,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        labelText: "Price",
                        prefixIcon: Icon(FontAwesomeIcons.moneyBillAlt),
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      controller: priceController,
                    ),
                    Text(
                      "Price in $currencySymbol $currencyCode",
                      textAlign: TextAlign.end,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        labelText: "Sale Price",
                        prefixIcon: Icon(FontAwesomeIcons.moneyBillAlt),
                      ),
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      controller: salePriceController,
                    ),
                    Text(
                      "Price in $currencySymbol $currencyCode",
                      textAlign: TextAlign.end,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    if (_categories != null && _categories.length > 0) ...[
                      DropdownButtonFormField(
                        decoration: InputDecoration(
                          filled: true,
                          labelText: "Category",
                        ),
                        items: _categories.map((c) {
                          return DropdownMenuItem(
                            value: c.id,
                            child: Text(c.id),
                          );
                        }).toList(),
                        value: category,
                        onChanged: (v) {
                          setState(() {
                            category = v;
                          });
                        },
                      ),
                    ],
                    SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text("Featured?"),
                        Switch(
                          value: isFeatured,
                          onChanged: (v) {
                            setState(() {
                              isFeatured = v;
                            });
                          },
                        ),
                        FlatButton(
                          onPressed: () {
                            showMyDialog(
                                context: context,
                                title: "Featured Product",
                                description:
                                    "Featured product is used to market your product, When you turn on Featured switch, your product will be displayed at top, with special look.");
                          },
                          child: Text("What is Featured?"),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      onPressed: () {
                        onUpdateProductBtnTap();
                      },
                      child: Text("SAVE"),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
