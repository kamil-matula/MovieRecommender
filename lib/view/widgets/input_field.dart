import 'package:flutter/material.dart';

/// TODO: Customise it
class CustomInputField extends StatelessWidget {
  final TextEditingController? controller;
  final bool obscureText;

  const CustomInputField({
    Key? key,
    this.controller,
    this.obscureText = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      obscuringCharacter: '*',

      // Borders:
      decoration: InputDecoration(
        enabledBorder: createBorderStyle(),
        errorBorder: createBorderStyle(),
        focusedErrorBorder: createBorderStyle(),
        focusedBorder: createBorderStyle(),
      ),
    );
  }

  OutlineInputBorder createBorderStyle() {
    return OutlineInputBorder(borderRadius: BorderRadius.circular(15));
  }
}
