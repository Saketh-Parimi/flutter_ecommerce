import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/products/product_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class YourProductsScreen extends StatelessWidget {
  const YourProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = productController.userProducts;
    return Scaffold(
      appBar: AppBar(title: Text("Your Products")),
      body: Obx(() => ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Get.to(ProductDetailScreen(product: products[index]));
                },
                child: ListTile(
                  title: Text(products[index].title),
                  leading: Text('Qty: ${products[index].qty}'),
                  trailing: Text('Price: ${products[index].price}'),
                ),
              );
            },
          )),
    );
  }
}
