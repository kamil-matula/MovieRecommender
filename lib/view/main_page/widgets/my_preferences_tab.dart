import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_recommender/constants/constant_movie_attributes.dart';
import 'package:movie_recommender/constants/constant_texts.dart';
import 'package:movie_recommender/constants/constant_typography.dart';
import 'package:movie_recommender/models/movie_attribute.dart';
import 'package:movie_recommender/view/widgets/custom_button.dart';

class MyPreferencesTab extends StatefulWidget {
  const MyPreferencesTab({Key? key}) : super(key: key);

  @override
  State<MyPreferencesTab> createState() => _MyPreferencesTabState();
}

class _MyPreferencesTabState extends State<MyPreferencesTab> {
  final List<MovieAttribute> _attributes =
      movie_attributes.map((e) => e.copyWith(value: 5)).toList();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              MATCH_MOVIES_HEADER,
              style: MOVIE_TITLE_STYLE,
            ),
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _attributes.length,
            itemBuilder: (_, index) {
              return _row(index);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: SizedBox(
              width: 200,
              child: CustomButton(
                text: MATCH_MOVIES,
                onPressed: _matchMovie,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _row(int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 15, 35, 5),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 350,
            child: Text(
              _attributes[index].description!,
              style: MOVIE_PREFERENCE_STYLE,
            ),
          ),
          RatingBar.builder(
            maxRating: 5,
            itemSize: 40,
            allowHalfRating: true,
            initialRating: 2.5,
            itemPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) {
              _attributes[index] = _attributes[index].copyWith(
                value: (rating * 2).toInt(),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _matchMovie() async {
    /// TODO: match movie with KNN and remove this printing
    _attributes.forEach((element) {
      print('${element.name}\t${element.value}');
    });
  }
}
