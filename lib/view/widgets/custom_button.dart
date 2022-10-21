import 'package:flutter/material.dart';

/// TODO: Customise it
class CustomButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const CustomButton({
    Key? key,
    this.text = '',
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(shape: const StadiumBorder()),
        child: Text(
          text,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
