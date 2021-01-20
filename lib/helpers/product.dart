import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseStorage storage = FirebaseStorage();

Future<String> uploadProductImage(String imageName, File image) async {
  final StorageReference storageReference =
      FirebaseStorage().ref().child("product_images").child(imageName);

  final StorageUploadTask uploadTask = storageReference.putFile(image);

  StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
  return await storageTaskSnapshot.ref.getDownloadURL();
}

Future<dynamic> addProduct(
    String productImage,
    String productName,
    String description,
    double price,
    double salePrice,
    String category,
    bool isFeatured) async {
  return await firestore.collection("products").add({
    "created_at": FieldValue.serverTimestamp(),
    "updated_at": FieldValue.serverTimestamp(),
    "productImage": productImage,
    "productName": productName,
    "description": description,
    "price": price,
    "salePrice": salePrice,
    "category": category,
    "isFeatured": isFeatured,
  });
}

Future<void> updateProduct(String docid, String productName, String description,
    double price, double salePrice, String category, bool isFeatured) async {
  return await firestore.collection("products").doc(docid).update({
    "updated_at": FieldValue.serverTimestamp(),
    "productName": productName,
    "description": description,
    "price": price,
    "salePrice": salePrice,
    "category": category,
    "isFeatured": isFeatured,
  });
}

Future<void> deleteProduct(String docid, String image) async {
  StorageReference imgRef = await storage.getReferenceFromUrl(image);
  await imgRef.delete();
  return await firestore.collection("products").doc(docid).delete();
}

Future<QuerySnapshot> getProducts() async {
  return await firestore
      .collection("products")
      .orderBy("created_at", descending: true)
      .limit(20)
      .get();
}

Future<QuerySnapshot> getMoreProducts(DocumentSnapshot lastDocument) async {
  return await firestore
      .collection("products")
      .orderBy("created_at", descending: true)
      .startAfterDocument(lastDocument)
      .limit(20)
      .get();
}

Future<QuerySnapshot> searchProduct(String searchValue) async {
  return await firestore
      .collection("products")
      .where("productName", isGreaterThanOrEqualTo: searchValue)
      .where("productName", isLessThanOrEqualTo: searchValue + '\uf8ff')
      .limit(20)
      .get();
}

Future<QuerySnapshot> getProductsByCategory(String category) async {
  return await firestore
      .collection("products")
      .where("category", isEqualTo: category)
      .limit(20)
      .get();
}

Future<QuerySnapshot> getMoreProductsByCategory(
    String category, DocumentSnapshot lastDocument) async {
  return await firestore
      .collection("products")
      .where("category", isEqualTo: category)
      .startAfterDocument(lastDocument)
      .limit(20)
      .get();
}
