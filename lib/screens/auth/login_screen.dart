import 'package:e_commerce/controllers/auth_controller.dart';
import 'package:e_commerce/screens/auth/register_screen.dart';
import 'package:e_commerce/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _authController = AuthController.instance;

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        CustomTextField(
          controller: _emailController,
          icon: Icons.mail,
          hintText: 'email',
          validator: (value) {},
        ),
        CustomTextField(
          controller: _passwordController,
          icon: Icons.lock,
          hintText: 'password',
          obscureText: true,
          validator: (value) {},
        ),
        ElevatedButton(
          onPressed: () {
            _authController.loginUser(
                _emailController.text, _passwordController.text);
          },
          child: Text('Sign In!'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Don\'t have an account?'),
            TextButton(
                onPressed: () {
                  Get.offAll(RegisterScreen());
                },
                child: Text('Click here!'))
          ],
        ),
      ]),
    );
  }
}
