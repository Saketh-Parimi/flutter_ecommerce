import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key? key,
    required TextEditingController controller,
    required this.icon,
    required this.hintText,
    this.obscureText = false,
    required this.validator,
  })  : _usernameController = controller,
        super(key: key);

  final TextEditingController _usernameController;
  final IconData icon;
  final String hintText;
  final bool obscureText;
  final String? Function(String?) validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        validator: validator,
        controller: _usernameController,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ),
    );
  }
}
