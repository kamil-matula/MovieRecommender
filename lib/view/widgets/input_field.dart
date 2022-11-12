import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_recommender/constants/colors.dart';
import 'package:movie_recommender/constants/texts.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController? controller;
  final bool obscureText;
  final String labelText;
  final double width;
  final int lengthLimit;
  final bool digitOnly;

  const CustomInputField({
    Key? key,
    this.controller,
    this.obscureText = false,
    this.labelText = '',
    this.width = 500,
    this.lengthLimit = 50,
    this.digitOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        obscuringCharacter: OBSCURING_CHARACTER,
        style: const TextStyle(
          fontSize: 17,
          color: CustomColors.darkBlue,
        ),
        // Borders:
        decoration: InputDecoration(
          enabledBorder: _createBorderStyle(),
          errorBorder: _createBorderStyle(),
          focusedErrorBorder: _createBorderStyle(),
          focusedBorder: _createBorderStyle(),
          fillColor: CustomColors.lightBlueOp,
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          labelText: labelText,
          labelStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w300,
          ),
        ),
        inputFormatters: _createInputFormatters(),
        keyboardType: _createTextInputType(),
      ),
    );
  }

  OutlineInputBorder _createBorderStyle() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: const BorderSide(color: CustomColors.lightBlue),
    );
  }

  TextInputType _createTextInputType() {
    if (digitOnly) {
      return const TextInputType.numberWithOptions();
    } else {
      return TextInputType.text;
    }
  }

  List<TextInputFormatter> _createInputFormatters() {
    List<TextInputFormatter> formatters = [
      LengthLimitingTextInputFormatter(lengthLimit)
    ];
    if (digitOnly) {
      formatters.add(FilteringTextInputFormatter.allow(RegExp('[0-9]+')));
    }
    return formatters;
  }
}
