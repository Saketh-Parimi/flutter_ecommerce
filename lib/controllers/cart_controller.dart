import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  static CartController instance = Get.put(CartController());

  RxList<ProductModel> userCartProducts = RxList<ProductModel>([]);

  late CollectionReference _ref;

  @override
  void onInit() {
    _ref = FirebaseFirestore.instance.collection('cart');
    getUserCartProducts(FirebaseAuth.instance.currentUser!.uid);
    super.onInit();
  }

  void getUserCartProducts(String uid) async {
    return await _ref.where('uid', isEqualTo: uid).get().then((value) {
      final s = value.docs.map((item) => ProductModel.fromSnap(item)).toList();
      userCartProducts.assignAll(s);
      print(userCartProducts);
    });
  }

  void addCartProduct(ProductModel product) async {
    try {
      await FirebaseFirestore.instance
          .collection('cart')
          .add(product.toMap())
          .then((value) async {
        Get.snackbar('Successful', 'Successfully added product to cart');
      });
    } catch (e) {
      Get.snackbar('Error adding product to cart', e.toString());
    }
  }
}
