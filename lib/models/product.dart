import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id;
  final String title;
  final String description;
  final double price;
  String imageUrl;
  final String uid;
  final int qty;

  ProductModel({
    required this.id,
    required this.qty,
    required this.uid,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'qty': qty,
      'uid': uid,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
      uid: map['uid'] ?? '',
      qty: map['qty'] ?? '',
    );
  }

  static ProductModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return ProductModel(
      id: snapshot['id'],
      title: snapshot['title'],
      description: snapshot['description'],
      price: snapshot['price'],
      imageUrl: snapshot['imageUrl'],
      uid: snapshot['uid'],
      qty: snapshot['qty'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));
}
