import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/controllers/auth_controller.dart';
import 'package:e_commerce/controllers/product_controller.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/screens/add_product_screen.dart';
import 'package:e_commerce/screens/product_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final _productController = ProductController.instance;

  @override
  Widget build(BuildContext context) {
    print(_productController.products.toList());
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
          leading: IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthController.instance.logoutUser();
            },
          ),
          actions: [
            Text(FirebaseAuth.instance.currentUser!.email.toString()),
            GestureDetector(
              child: Icon(Icons.add),
              onTap: () => Get.to(() => AddProductScreen()),
            )
          ],
        ),
        body: Obx(
          () => GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            itemCount: _productController.products.length,
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: GridTile(
                  footer: GridTileBar(
                    backgroundColor: Colors.black87,
                    title: Text(_productController.products[index].title),
                    trailing: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.shopping_cart)),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => ProductDetailScreen(
                              product: ProductModel(
                            qty: _productController.products[index].qty,
                            uid: FirebaseAuth.instance.currentUser!.uid,
                            description:
                                _productController.products[index].description,
                            id: _productController.products[index].id,
                            imageUrl:
                                _productController.products[index].imageUrl,
                            price: _productController.products[index].price,
                            title: _productController.products[index].title,
                          )));
                    },
                    child: Image.network(
                      _productController.products[index].imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              );
            },
          ),
        ));
  }
}
