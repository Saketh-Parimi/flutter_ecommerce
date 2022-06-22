import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProductController extends GetxController {
  static ProductController instance = Get.put(ProductController());

  bool isLoading = false;

  RxList<ProductModel> products = RxList<ProductModel>([]);

  late CollectionReference _ref;

  @override
  void onInit() {
    _ref = FirebaseFirestore.instance.collection('products');
    products.bindStream(getAllProducts());
    print(products);
    super.onInit();
  }

  Stream<List<ProductModel>> getAllProducts() => _ref.snapshots().map((event) =>
      event.docs.map((item) => ProductModel.fromSnap(item)).toList());

  Future<String> _uploadFile(String id, XFile image) async {
    try {
      isLoading = true;

      final path = 'images/$id';
      final file = File(image.path);

      final ref = FirebaseStorage.instance.ref().child(path);
      UploadTask uploadTask = ref.putFile(file);

      final String urlLink = await (await uploadTask).ref.getDownloadURL();

      print('url link is: $urlLink');

      return urlLink;
    } catch (e) {
      Get.snackbar('Error uploading file', e.toString());
      return '';
    }
  }

  void addProduct(ProductModel productModel, XFile? image) async {
    try {
      if (image == null) {
        Get.snackbar('Image not selected', 'Please select and image');
        return;
      }
      await FirebaseFirestore.instance
          .collection('products')
          .add(productModel.toMap())
          .then((doc) async {
        productModel.id = doc.id;
        final downloadUrl = await _uploadFile(doc.id, image);
        print(downloadUrl);
        if (downloadUrl == null || downloadUrl == '') {
          Get.snackbar('Error', 'error uploading image. Please try again.');
          print('deleting product');
          await FirebaseFirestore.instance
              .collection('products')
              .doc(doc.id)
              .delete();
          return;
        }
        productModel.imageUrl = downloadUrl;
        print(downloadUrl);
        doc.set(productModel.toMap());
        print('just set product');
        Get.back();
        Get.snackbar('Success', 'Successfully added product');
      });
    } catch (e) {
      Get.snackbar('Cannot add product', e.toString());
    }
  }
}
