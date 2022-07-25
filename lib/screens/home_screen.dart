import 'package:e_commerce/constants.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/screens/add_product_screen.dart';
import 'package:e_commerce/screens/cart_items_overview_screen.dart';
import 'package:e_commerce/screens/product_detail_screen.dart';
import 'package:e_commerce/screens/your_products_screen.dart';
import 'package:e_commerce/widgets/badge.dart';
import 'package:e_commerce/widgets/custom_text_field.dart';
import 'package:e_commerce/widgets/number_text_field.dart';
import 'package:e_commerce/widgets/qty_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final _qtyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                FirebaseAuth.instance.currentUser!.email.toString(),
              ),
            ),
            ListTile(
              title: const Text('View Your Products'),
              leading: const Icon(FontAwesomeIcons.bagShopping),
              onTap: () {
                Get.to(() => const YourProductsScreen());
              },
            ),
            ListTile(
              title: const Text('Add Product'),
              leading: const Icon(Icons.add),
              onTap: () {
                Get.to(() => const AddProductScreen());
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          Obx(() => Badge(
              value: cartController.userCartProducts.length.toString(),
              child: IconButton(
                onPressed: () {
                  Get.to(() => CartItemsOverviewScreen());
                },
                icon: Icon(
                  Icons.shopping_cart,
                ),
              )))
        ],
      ),
      body: Obx(
        () => GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 5.0,
          ),
          itemCount: productController.products.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: GridTile(
                footer: GridTileBar(
                  backgroundColor: Colors.black87,
                  title: Text(productController.products[index].title),
                  trailing: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return QtyDialog(
                              qty: productController.products[index].qty,
                              qtyController: _qtyController,
                              product: productController.products[index],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.shopping_cart)),
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.to(
                      () => ProductDetailScreen(
                        product: ProductModel(
                          qty: productController.products[index].qty,
                          uid: FirebaseAuth.instance.currentUser!.uid,
                          description:
                              productController.products[index].description,
                          id: productController.products[index].id,
                          imageUrl: productController.products[index].imageUrl,
                          price: productController.products[index].price,
                          title: productController.products[index].title,
                        ),
                      ),
                    );
                  },
                  child: Image.network(
                    productController.products[index].imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
