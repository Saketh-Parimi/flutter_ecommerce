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
    });
  }

  void addCartProduct(ProductModel product) async {
    try {
      QuerySnapshot snap = await _ref.where("id", isEqualTo: product.id).get();
      if (snap.docs.isEmpty) {
        _ref.doc(product.id).set(product.toMap());
      } else {
        final updatedQty =
            (snap.docs.first.data() as Map<String, dynamic>)['qty'] +
                product.qty;
        final updatedPrice =
            (snap.docs.first.data() as Map<String, dynamic>)['price'] +
                product.price;
        _ref.doc(product.id).update({
          "qty": updatedQty,
          "price": updatedPrice,
        });
      }
      Get.snackbar('Successful', "Successfully added product to cart");
      getUserCartProducts(FirebaseAuth.instance.currentUser!.uid);
    } catch (e) {
      Get.snackbar('Error adding product to cart', e.toString());
    }
  }

  void orderProducts() {
    
  }
}
