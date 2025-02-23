import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData? icon;
  final String hintText;
  final bool obscureText;
  final FocusNode? focusNode;
  final TextInputType? textInputType;

  const MyTextField({
    super.key,
    required this.controller,
    required this.icon,
    required this.hintText,
    required this.obscureText,
    this.focusNode,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: textInputType,
      decoration: InputDecoration(
        prefixIcon: icon != null
            ? Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : null,
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
        enabledBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:
              BorderSide(color: Theme.of(context).colorScheme.secondary),
        ),
      ),
      obscureText: obscureText,
    );
  }
}
