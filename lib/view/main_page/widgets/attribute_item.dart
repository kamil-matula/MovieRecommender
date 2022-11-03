import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_recommender/constants/constant_typography.dart';
import 'package:movie_recommender/models/movie_attribute.dart';

class AttributeItem extends StatefulWidget {
  final MovieAttribute attribute;
  final bool ignoreGestures;
  final int index;
  final void Function(double, int)? onRatingUpdate;

  const AttributeItem({
    Key? key,
    required this.attribute,
    this.ignoreGestures = false,
    this.onRatingUpdate,
    this.index = 0,
  }) : super(key: key);

  @override
  State<AttributeItem> createState() => _AttributeItemState();
}

class _AttributeItemState extends State<AttributeItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.attribute.name,
            style: MOVIE_ATTRIBUTE_STYLE,
          ),
          RatingBar.builder(
            maxRating: 5,
            itemSize: 28,
            allowHalfRating: true,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
            ignoreGestures: widget.ignoreGestures,
            onRatingUpdate: (rating) {
              if (widget.onRatingUpdate != null) {
                widget.onRatingUpdate!(rating, widget.index);
              }
            },
            initialRating: widget.attribute.value.toDouble() / 2,
          ),
        ],
      ),
    );
  }
}
