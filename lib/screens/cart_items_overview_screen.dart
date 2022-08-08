import 'package:e_commerce/constants.dart';
import 'package:e_commerce/screens/products/product_detail_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartItemsOverviewScreen extends StatelessWidget {
  const CartItemsOverviewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartProducts = cartController.userCartProducts;
    return Scaffold(
      appBar: AppBar(title: Text("Your Products")),
      body: ListView.builder(
        itemCount: cartProducts.length,
        itemBuilder: (context, index) {
          cartController
              .getUserCartProducts(FirebaseAuth.instance.currentUser!.uid);
          return ListTile(
            title: Text(cartProducts[index].title),
            subtitle: Text(cartProducts[index].description),
            leading: Text('Qty: ${cartProducts[index].qty}'),
            trailing: Text('Price: ${cartProducts[index].price}'),
          );
        },
      ),
    );
  }
}
