import 'package:flutter/material.dart';
import 'package:movie_recommender/constants/colors.dart';

class CustomTypography {
  static const FontWeight _regular = FontWeight.w400;
  static const FontWeight _medium = FontWeight.w500;
  static const FontWeight _semibold = FontWeight.w600;

  static const TextStyle h1 = TextStyle(fontSize: 40, fontWeight: _medium);

  static const TextStyle p1MediumBlack =
      TextStyle(fontSize: 24, fontWeight: _medium, color: CustomColors.black);

  static const TextStyle p2Regular =
      TextStyle(fontSize: 20, fontWeight: _regular);
  static const TextStyle p2Semibold =
      TextStyle(fontSize: 20, fontWeight: _semibold);

  static const TextStyle p3Regular = TextStyle(
    fontSize: 18,
    fontWeight: _regular,
    color: CustomColors.carbonFiber,
  );
  static const TextStyle p3Medium = TextStyle(
    fontSize: 18,
    fontWeight: _medium,
    color: CustomColors.carbonFiber,
  );

  static const TextStyle p4RegularBlack =
      TextStyle(fontSize: 16, fontWeight: _regular, color: CustomColors.black);
  static const TextStyle p4MediumItalicGray = TextStyle(
    fontSize: 16,
    fontWeight: _medium,
    fontStyle: FontStyle.italic,
    color: CustomColors.iron,
  );
}
