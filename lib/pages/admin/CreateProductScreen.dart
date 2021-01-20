import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myshop/components/MyDialog.dart';
import 'package:myshop/config/colors.dart';
import 'package:myshop/config/currency.dart';
import 'package:myshop/helpers/category.dart';
import 'package:myshop/helpers/product.dart';
import 'package:path/path.dart' as path;

class CreateProductScreen extends StatefulWidget {
  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

enum ImagePickCategory { camera, phone }

class _CreateProductScreenState extends State<CreateProductScreen> {
  File _productImage;

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
        category = qsnap.docs[0].id;
        _loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  onCreateProductBtnTap() async {
    try {
      String productName = productNameController.text;
      String description = productDescriptionController.text;

      if (productName.isNotEmpty &&
          priceController.text.isNotEmpty &&
          salePriceController.text.isNotEmpty &&
          _productImage != null) {
        String productImageName = path.basename(_productImage.path);
        double price = double.parse(priceController.text);
        double salePrice = double.parse(salePriceController.text);

        if (salePrice <= price) {
          // showMyLoadingModal(
          //   context,
          //   "Please wait...",
          // );
          setState(() {
            _loading = true;
          });
          print(
              "$productName \n $description \n $price $salePrice $productImageName \n $category  $isFeatured");

          uploadProductImage(
            productImageName,
            _productImage,
          ).then((downloadURL) {
            addProduct(
              downloadURL,
              productName,
              description,
              price,
              salePrice,
              category,
              isFeatured,
            ).then((v) {
              Navigator.pop(context, "done");
            });
          }).catchError((e) {
            print(e);
            Navigator.pop(context, "failed");
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

  _pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      builder: (ctx) {
        return Container(
          height: 200,
          color: Colors.transparent,
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text("Take a Picture from Camera"),
                onTap: () {
                  _takeImage(ImagePickCategory.camera);

                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                leading: Icon(Icons.image),
                title: Text("Select a Picture from Device"),
                onTap: () {
                  _takeImage(ImagePickCategory.phone);
                  Navigator.pop(ctx);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _takeImage(ImagePickCategory selection) async {
    try {
      final picker = ImagePicker();

      File _tempFile;

      // pick image
      if (selection == ImagePickCategory.camera) {
        final pickedFile = await picker.getImage(source: ImageSource.camera);
        _tempFile = File(pickedFile.path);
      } else if (selection == ImagePickCategory.phone) {
        final pickedFile = await picker.getImage(source: ImageSource.gallery);
        _tempFile = File(pickedFile.path);
      }

      // crop image

      File croppedFile = await ImageCropper.cropImage(
        sourcePath: _tempFile.path,
        compressQuality: 30,
        compressFormat: ImageCompressFormat.jpg,
        maxHeight: 1920,
        maxWidth: 1920,
      );

      print(croppedFile.lengthSync());

      setState(() {
        _productImage = croppedFile;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Product"),
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
                    InkWell(
                      onTap: () {
                        _pickImage();
                      },
                      child: _productImage == null
                          ? Container(
                              height: 280,
                              color: Colors.grey,
                              child: Icon(Icons.add_a_photo),
                            )
                          : Image.file(
                              _productImage,
                              height: 280,
                              fit: BoxFit.cover,
                            ),
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
                        onCreateProductBtnTap();
                      },
                      child: Text("CREATE PRODUCT"),
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
