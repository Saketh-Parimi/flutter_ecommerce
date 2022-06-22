import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String name;
  final String email;
  final String uid;

  UserModel({required this.name, required this.email, required this.uid});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
    };
  }

  static UserModel fromSnap(DocumentSnapshot snap) {
    final snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
        name: snapshot['name'], email: snapshot['emial'], uid: snapshot['uid']);
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));
}
