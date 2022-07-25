import 'package:e_commerce/controllers/cart_controller.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/widgets/number_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QtyDialog extends StatelessWidget {
  final int qty;
  final TextEditingController qtyController;
  final ProductModel product;

  const QtyDialog({
    Key? key,
    required this.qty,
    required this.qtyController,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: Text('Quanity'),
      content: Column(
        children: [
          NumberTextField(
            controller: qtyController,
            max: qty,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (qtyController.text.isEmpty) {
              Get.snackbar(
                  'No item entered', 'Please enter a number for the quantity');
              return;
            }
            CartController.instance.addCartProduct(ProductModel(
                id: product.id,
                qty: int.parse(qtyController.text),
                uid: FirebaseAuth.instance.currentUser!.uid,
                title: product.title,
                description: product.description,
                price: product.price * int.parse(qtyController.text),
                imageUrl: product.imageUrl));
            Get.snackbar('Success', 'Successfully added product to cart');
            Get.back();
          },
          child: Text('submit'),
        )
      ],
    );
  }
}
