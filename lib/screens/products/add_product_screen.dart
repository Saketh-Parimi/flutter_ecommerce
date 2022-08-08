import 'dart:typed_data';

import 'package:e_commerce/controllers/product_controller.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _qtyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  XFile? _image;
  Uint8List? convertedImage;

  void _showImgFromGallery() async {
    final picker = ImagePicker();
    XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    // I put setState here because this image isn't associated with any of the controllers.
    setState(() {
      _image = image;
    });
    if (_image == null) {
      Get.snackbar('No image selected', 'Please select an image');
    } else {
      convertedImage = await _image!.readAsBytes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add a product')),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      _showImgFromGallery();
                    },
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white.withOpacity(.53),
                      child: convertedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.memory(
                                convertedImage!,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.6),
                                  borderRadius: BorderRadius.circular(50)),
                              width: 100,
                              height: 100,
                              child: Icon(
                                Icons.camera_alt,
                                color: Colors.grey[800],
                              ),
                            ),
                    ),
                  ),
                ),
                CustomTextField(
                  controller: _titleController,
                  icon: Icons.title,
                  hintText: 'Title',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter value for title';
                    }
                  },
                ),
                CustomTextField(
                  controller: _descriptionController,
                  icon: Icons.description,
                  hintText: 'Description',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter value for description';
                    }
                  },
                ),
                CustomTextField(
                  controller: _priceController,
                  icon: Icons.price_change,
                  hintText: 'Price',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter value for price';
                    }
                  },
                ),
                CustomTextField(
                  controller: _qtyController,
                  icon: Icons.numbers,
                  hintText: 'Quantity',
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter value for quantity';
                    }
                  },
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // I put id as 'as' is because in the addProduct method, we change the id to the document id because we get the doc id after adding it to the database.
                        productController.addProduct(
                          ProductModel(
                              id: 'as',
                              qty: int.parse(_qtyController.text),
                              uid: FirebaseAuth.instance.currentUser!.uid,
                              title: _titleController.text,
                              description: _descriptionController.text,
                              price: double.parse(_priceController.text),
                              imageUrl: ''),
                          _image,
                        );
                      }
                    },
                    child: productController.isLoading
                        ? CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : Text("submit"))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
