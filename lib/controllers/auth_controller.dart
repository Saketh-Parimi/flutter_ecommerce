import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../screens/auth/login_screen.dart';
import '../screens/home_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.put(AuthController());

  late Rx<User?> _user;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(FirebaseAuth.instance.currentUser);
    _user.bindStream(FirebaseAuth.instance.authStateChanges());
    ever(_user, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => LoginScreen());
    } else {
      Get.offAll(() => HomeScreen());
    }
  }

  void registerUser(String username, String email, String password) async {
    try {
      if (username.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
        UserCredential cred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        UserModel user =
            UserModel(name: username, email: email, uid: cred.user!.uid);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toMap());
      } else {
        print('asfddfsa');
        Get.snackbar('Cannot register', 'Please enter all fields');
      }
    } catch (e) {
      Get.snackbar('Error registering', e.toString());
    }
  }

  void loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } else {
        Get.snackbar('Cannot login', 'Please enter all fields');
      }
    } catch (e) {
      Get.snackbar('Error logging in', e.toString());
    }
  }

  void logoutUser() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      Get.snackbar('Cannot Logout', e.toString());
    }
  }
}
