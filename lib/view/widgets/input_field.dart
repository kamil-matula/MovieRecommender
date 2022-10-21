import 'package:flutter/material.dart';

/// TODO: Customise it
class CustomInputField extends StatelessWidget {
  final TextEditingController? controller;
  final bool obscureText;
  final String labelText;

  const CustomInputField({
    Key? key,
    this.controller,
    this.obscureText = false,
    this.labelText = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      obscuringCharacter: '●',
      style: const TextStyle(
        fontSize: 18,
        color: Color(0xFF0F183D),
      ),
      // Borders:
      decoration: InputDecoration(
        enabledBorder: createBorderStyle(),
        errorBorder: createBorderStyle(),
        focusedErrorBorder: createBorderStyle(),
        focusedBorder: createBorderStyle(),
        fillColor: const Color(0x4D3589EC),
        filled: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        labelText: labelText,
        labelStyle: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  OutlineInputBorder createBorderStyle() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: Color(0x3589EC)),
    );
  }
}
