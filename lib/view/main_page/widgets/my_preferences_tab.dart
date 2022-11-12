import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:movie_recommender/constants/texts.dart';
import 'package:movie_recommender/constants/typography.dart';
import 'package:movie_recommender/models/movie.dart';
import 'package:movie_recommender/models/user.dart';
import 'package:movie_recommender/view/main_page/cubit/my_preferences_cubit.dart';
import 'package:movie_recommender/view/output_dialog/output_dialog.dart';
import 'package:movie_recommender/view/widgets/custom_button.dart';

class MyPreferencesTab extends StatefulWidget {
  const MyPreferencesTab({Key? key}) : super(key: key);

  @override
  State<MyPreferencesTab> createState() => _MyPreferencesTabState();
}

class _MyPreferencesTabState extends State<MyPreferencesTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text(
              MATCH_MOVIES_HEADER,
              style: CustomTypography.p2Semibold,
              textAlign: TextAlign.center,
            ),
          ),
          BlocBuilder<MyPreferencesCubit, User?>(
            builder: (_, user) {
              if (user == null) return const SizedBox();
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: user.preferences.length,
                itemBuilder: (context, index) => _row(context, user, index),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: SizedBox(
              width: 200,
              child: CustomButton(
                text: MATCH_MOVIES,
                onPressed: () async {
                  MyPreferencesCubit cubit = context.read<MyPreferencesCubit>();
                  List<Movie> matchedMovies = await cubit.getMatchingMovies();
                  if (!mounted) return;

                  showDialog(
                    context: context,
                    builder: (_) => OutputDialog(matchedMovies: matchedMovies),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _row(BuildContext context, User user, int index) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(35, 15, 35, 5),
      child: Column(
        children: [
          SizedBox(
            width: 350,
            child: Text(
              user.preferences[index].description ?? '',
              style: CustomTypography.p2Regular,
            ),
          ),
          RatingBar.builder(
            maxRating: 5,
            allowHalfRating: true,
            initialRating: user.preferences[index].value / 2,
            itemPadding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 3,
            ),
            itemBuilder: (_, __) => const Icon(Icons.star, color: Colors.amber),
            onRatingUpdate: (rating) async {
              context
                  .read<MyPreferencesCubit>()
                  .updateAttribute(user, index, (rating * 2).toInt());
            },
          ),
        ],
      ),
    );
  }
}
