import 'package:flutter/material.dart';
import 'package:movie_recommender/constants/constant_colors.dart';
import 'package:movie_recommender/constants/constant_texts.dart';

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
      obscuringCharacter: OBSCURING_CHARACTER,
      style: const TextStyle(
        fontSize: 18,
        color: FORM_TEXT_COLOR,
      ),
      // Borders:
      decoration: InputDecoration(
        enabledBorder: createBorderStyle(),
        errorBorder: createBorderStyle(),
        focusedErrorBorder: createBorderStyle(),
        focusedBorder: createBorderStyle(),
        fillColor: FORM_BACKGROUND_COLOR,
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
      borderSide: const BorderSide(color: FORM_BORDER_COLOR),
    );
  }
}
