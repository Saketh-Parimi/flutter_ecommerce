import 'package:e_commerce/controllers/auth_controller.dart';
import 'package:e_commerce/screens/auth/login_screen.dart';
import 'package:e_commerce/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _authController = AuthController.instance;

    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        CustomTextField(
          controller: _usernameController,
          hintText: 'Username',
          icon: Icons.person,
          validator: (value) {},
        ),
        CustomTextField(
          controller: _emailController,
          hintText: 'Email',
          icon: Icons.mail,
          validator: (value) {},
        ),
        CustomTextField(
            controller: _passwordController,
            hintText: 'Password',
            icon: Icons.lock,
            validator: (value) {},
            obscureText: true),
        ElevatedButton(
          onPressed: () {
            _authController.registerUser(_usernameController.text,
                _emailController.text, _passwordController.text);
          },
          child: Text('Sign Up!'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Already have an account?'),
            TextButton(
                onPressed: () {
                  Get.offAll(LoginScreen());
                },
                child: Text('Click here!'))
          ],
        ),
      ]),
    );
  }
}
